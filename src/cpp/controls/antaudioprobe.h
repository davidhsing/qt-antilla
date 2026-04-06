#pragma once
#include <QtCore/QObject>
#include <QtCore/QTimer>
#include <QtMultimedia/QAudioSource>
#include <QtMultimedia/QMediaDevices>
#include <QtCore/QIODevice>
#include <QtQml/qqml.h>
#include "../antglobal.h"


class ANTILLA_EXPORT AntAudioProbe : public QObject {
    Q_OBJECT
    QML_NAMED_ELEMENT(AntAudioProbe)

    Q_PROPERTY(QString deviceId READ deviceId WRITE setDeviceId NOTIFY deviceIdChanged)
    Q_PROPERTY(bool deviceValid READ deviceValid NOTIFY deviceValidChanged)
    Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged)
    Q_PROPERTY(float level READ level NOTIFY levelChanged)
    Q_PROPERTY(int interval READ interval WRITE setInterval NOTIFY intervalChanged)
    Q_PROPERTY(bool fallbackDefault READ fallbackDefault WRITE setFallbackDefault NOTIFY fallbackDefaultChanged)

public:
    explicit AntAudioProbe(QObject* parent = nullptr);
    ~AntAudioProbe() override;

    [[nodiscard]] QString deviceId() const { return m_deviceId; }
    void setDeviceId(const QString& deviceId);
    [[nodiscard]] bool deviceValid() const { return m_deviceValid; }
    [[nodiscard]] bool active() const { return m_active; }
    void setActive(bool active);
    [[nodiscard]] float level() const { return m_level; }
    [[nodiscard]] int interval() const { return m_updateTimer->interval(); }
    void setInterval(int interval);
    [[nodiscard]] bool fallbackDefault() const { return m_fallbackDefault; }
    void setFallbackDefault(bool fallbackDefault);

public slots:
    void startProbing();
    void stopProbing();

signals:
    void deviceIdChanged();
    void deviceValidChanged();
    void activeChanged();
    void levelChanged();
    void intervalChanged();
    void fallbackDefaultChanged();

private slots:
    void handleAudioData();
    void handleAudioInputsChanged();

private:
    void initializeAudioSource();
    void cleanupAudioSource();
    void calculateLevel();
    void validateDevice();

    QAudioSource* m_audioSource = nullptr;
    QIODevice* m_audioDevice = nullptr;
    QTimer* m_updateTimer = nullptr;
    QMediaDevices* m_mediaDevices = nullptr;

    QString m_deviceId;
    bool m_deviceValid = false;
    bool m_active = true;
    float m_level = 0.0f;
    bool m_fallbackDefault = false;
};
