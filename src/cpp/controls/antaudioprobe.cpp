#include "antaudioprobe.h"
#include <cmath>
#include <QtCore/QDebug>
#include <QtMultimedia/QAudioFormat>
#include <QtMultimedia/QAudioDevice>

AntAudioProbe::AntAudioProbe(QObject* parent)
    : QObject(parent), m_updateTimer(new QTimer(this)), m_mediaDevices(new QMediaDevices(this)) {
    connect(m_updateTimer, &QTimer::timeout, this, &AntAudioProbe::handleAudioData);
    m_updateTimer->setInterval(50); // 20fps update rate
    // Connect to audio inputs change signal to handle hot-plugging
    connect(m_mediaDevices, &QMediaDevices::audioInputsChanged, this, &AntAudioProbe::handleAudioInputsChanged);
}

AntAudioProbe::~AntAudioProbe() {
    cleanupAudioSource();
}

void AntAudioProbe::setDeviceId(const QString& deviceId) {
    if (m_deviceId == deviceId) {
        return;
    }
    m_deviceId = deviceId;
    validateDevice();
    // Restart probing with new device if currently active
    if (m_active) {
        stopProbing();
        startProbing();
    }
    emit deviceIdChanged();
    emit deviceValidChanged();
}

void AntAudioProbe::setActive(const bool active) {
    if (m_active == active) {
        return;
    }
    m_active = active;
    if (m_active) {
        startProbing();
    } else {
        stopProbing();
    }
    emit activeChanged();
}

void AntAudioProbe::setInterval(const int interval) {
    if (m_updateTimer->interval() == interval) {
        return;
    }
    m_updateTimer->setInterval(interval);
    emit intervalChanged();
}

void AntAudioProbe::setFallbackDefault(const bool fallbackDefault) {
    if (m_fallbackDefault == fallbackDefault) {
        return;
    }
    m_fallbackDefault = fallbackDefault;
    validateDevice();
    // Restart probing with new device if currently active
    if (m_active) {
        stopProbing();
        startProbing();
    }
    emit fallbackDefaultChanged();
    emit deviceValidChanged();
}

void AntAudioProbe::startProbing() {
    if (!m_deviceValid || !m_active) {
        return;
    }
    initializeAudioSource();
    if (m_audioSource && m_audioDevice) {
        m_updateTimer->start();
    }
}

void AntAudioProbe::stopProbing() {
    m_updateTimer->stop();
    cleanupAudioSource();
    m_level = 0.0f;
    emit levelChanged();
}

void AntAudioProbe::initializeAudioSource() {
    cleanupAudioSource();
    // Find the appropriate device
    QAudioDevice device;
    if (!m_deviceId.isEmpty()) {
        const auto devices = QMediaDevices::audioInputs();
        for (const auto& dev: devices) {
            if (dev.id() == m_deviceId) {
                device = dev;
                break;
            }
        }
    }
    if (device.isNull() && m_fallbackDefault) {
        // Use default device
        device = QMediaDevices::defaultAudioInput();
    }
    // Set up audio format
    QAudioFormat format;
    format.setSampleRate(44100);
    format.setChannelCount(1);
    format.setSampleFormat(QAudioFormat::Int16);
    // Check if the format is supported
    if (!device.isFormatSupported(format)) {
        qWarning() << "Audio format not supported by device, trying nearest format";
        format = device.preferredFormat();
    }
    // Create audio source with format
    m_audioSource = new QAudioSource(device, format, this);
    // Start audio source
    m_audioDevice = m_audioSource->start();
    if (!m_audioDevice) {
        qWarning() << "Failed to start audio source";
        cleanupAudioSource();
    }
}

void AntAudioProbe::cleanupAudioSource() {
    if (m_audioDevice) {
        m_audioDevice->close();
        m_audioDevice = nullptr;
    }
    if (m_audioSource) {
        m_audioSource->deleteLater();
        m_audioSource = nullptr;
    }
}

void AntAudioProbe::handleAudioData() {
    calculateLevel();
}

void AntAudioProbe::calculateLevel() {
    if (!m_audioDevice) {
        return;
    }
    // Read available audio data
    const QByteArray buffer = m_audioDevice->readAll();
    if (buffer.isEmpty()) {
        return;
    }
    // Calculate RMS (Root Mean Square) for audio level
    const auto data = reinterpret_cast<const qint16*>(buffer.constData());
    const int sampleCount = buffer.size() / sizeof(qint16);
    if (sampleCount == 0) {
        return;
    }
    qint64 sum = 0;
    for (int i = 0; i < sampleCount; ++i) {
        sum += static_cast<qint64>(data[i]) * data[i];
    }
    // Calculate RMS and normalize to 0.0-1.0 range
    const double rms = std::sqrt(static_cast<double>(sum) / sampleCount);
    const double normalizedLevel = std::min(1.0, rms / 32768.0);
    // Ensure the level is always in [0,1] range
    m_level = static_cast<float>(std::max(0.0, std::min(1.0, normalizedLevel)));
    emit levelChanged();
}

void AntAudioProbe::validateDevice() {
    const bool wasValid = m_deviceValid;
    if (!m_deviceId.isEmpty()) {
        // Check if specified device exists
        const auto devices = QMediaDevices::audioInputs();
        m_deviceValid = false;
        for (const auto& dev: devices) {
            if (dev.id() == m_deviceId) {
                m_deviceValid = true;
                break;
            }
        }
    } else if (m_fallbackDefault) {
        // With fallback, we consider it valid if any input device exists
        m_deviceValid = !QMediaDevices::audioInputs().isEmpty();
    } else {
        // No device specified and no fallback
        m_deviceValid = false;
    }
    if (wasValid != m_deviceValid) {
        emit deviceValidChanged();
    }
    // If device becomes invalid while active, stop probing
    if (!m_deviceValid && m_active) {
        stopProbing();
    }
}

void AntAudioProbe::handleAudioInputsChanged() {
    // Re-validate device when audio inputs change (hot-plugging)
    validateDevice();
    // If we were probing and device became invalid, stop probing
    if (m_active && !m_deviceValid) {
        stopProbing();
    }
    // If we weren't probing but device became valid, and we're active, start probing
    if (m_active && m_deviceValid && !m_audioSource) {
        startProbing();
    }
}
