#include "antasynchasher.h"

#include <QtCore/QBuffer>
#include <QtCore/QDebug>
#include <QtCore/QFile>
#include <QtCore/QLoggingCategory>
#include <QtCore/QRunnable>
#include <QtCore/QThreadPool>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QtQml/QQmlEngine>

Q_LOGGING_CATEGORY(lcAntAsyncHasher, "antilla.basic.asynchasher");

class AsyncRunnable : public QObject, public QRunnable
{
    Q_OBJECT

public:
    AsyncRunnable(QIODevice *device, QCryptographicHash::Algorithm algorithm)
        : QObject{nullptr}, m_device(device), m_algorithm(algorithm)
    {
        setAutoDelete(false);
    }

    void cancel() {
        m_stop = true;
    }

signals:
    void progress(qint64 processed, qint64 total);
    void finished(const QString &result);

protected:
    virtual void run() {
        if (m_device) {
            static constexpr qint64 chunkSize = 4 * 1024 * 1024;
            QCryptographicHash hash(m_algorithm);
            qint64 processed = 0;
            qint64 total = m_device->size();
            while (!m_device->atEnd()) {
                if (m_stop) {
                    m_device->deleteLater();
                    return;
                }
                auto readData = m_device->read(std::min(chunkSize, total));
                hash.addData(readData);
                processed += readData.size();
                emit progress(processed, total);
            }
            emit finished(hash.result().toHex().toUpper());
            m_device->deleteLater();
        }
    }

    std::atomic_bool m_stop = { false };
    QIODevice *m_device = nullptr;
    QCryptographicHash::Algorithm m_algorithm;
};

class AntAsyncHasherPrivate
{
public:
    void cleanupRunnable()
    {
        if (m_runnable) {
            m_runnable->cancel();
            m_runnable->disconnect();
            m_runnable->deleteLater();
            m_runnable = nullptr;
        }
    }

    QCryptographicHash::Algorithm m_algorithm = QCryptographicHash::Md5;
    bool m_asynchronous = true;
    QString m_hashValue;
    QUrl m_source;
    QString m_sourceText;
    QByteArray m_sourceData;
    QObject *m_sourceObject = nullptr;
    QNetworkReply *m_reply = nullptr;
    QNetworkAccessManager *m_manager = nullptr;
    AsyncRunnable *m_runnable = nullptr;
};

AntAsyncHasher::AntAsyncHasher(QObject *parent)
    : QObject{parent}
    , d_ptr(new AntAsyncHasherPrivate)
{

}

AntAsyncHasher::~AntAsyncHasher()
{
    Q_D(AntAsyncHasher);

    d->cleanupRunnable();
}

QCryptographicHash::Algorithm AntAsyncHasher::algorithm()
{
    Q_D(AntAsyncHasher);

    return d->m_algorithm;
}

void AntAsyncHasher::setAlgorithm(QCryptographicHash::Algorithm algorithm)
{
    Q_D(AntAsyncHasher);

    if (d->m_algorithm != algorithm) {
        d->m_algorithm = algorithm;
        emit algorithmChanged();
        emit hashLengthChanged();
    }
}

bool AntAsyncHasher::asynchronous() const
{
    Q_D(const AntAsyncHasher);

    return d->m_asynchronous;
}

void AntAsyncHasher::setAsynchronous(bool async)
{
    Q_D(AntAsyncHasher);

    if (d->m_asynchronous != async) {
        d->m_asynchronous = async;
        emit asynchronousChanged();
    }
}

QString AntAsyncHasher::hashValue() const
{
    Q_D(const AntAsyncHasher);

    return d->m_hashValue;
}

int AntAsyncHasher::hashLength() const
{
    Q_D(const AntAsyncHasher);

    return QCryptographicHash::hashLength(d->m_algorithm);
}

QUrl AntAsyncHasher::source() const
{
    Q_D(const AntAsyncHasher);

    return d->m_source;
}

void AntAsyncHasher::setSource(const QUrl &source)
{
    Q_D(AntAsyncHasher);

    if (d->m_source != source) {
        d->m_source = source;
        emit sourceChanged();

        d->cleanupRunnable();

        if (source.isLocalFile()) {
            QFile *file = new QFile(source.toLocalFile());
            if (file->open(QIODevice::ReadOnly)) {
                emit started();
                if (d->m_asynchronous) {
                    d->m_runnable = new AsyncRunnable(file, d->m_algorithm);
                    connect(d->m_runnable, &AsyncRunnable::finished, this, &AntAsyncHasher::setHashValue, Qt::QueuedConnection);
                    connect(d->m_runnable, &AsyncRunnable::progress, this, &AntAsyncHasher::hashProgress, Qt::QueuedConnection);
                    QThreadPool::globalInstance()->start(d->m_runnable);
                    emit started();
                } else {
                    QCryptographicHash hash(d->m_algorithm);
                    hash.addData(file);
                    setHashValue(hash.result().toHex().toUpper());
                    file->deleteLater();
                }
            } else {
                qCWarning(lcAntAsyncHasher) << "File Error:" << file->errorString();
                file->deleteLater();
            }
        } else {
            if (d->m_reply)
                d->m_reply->abort();
            emit started();
            if (!d->m_manager) {
                if (qmlEngine(this)) {
                    d->m_manager = qmlEngine(this)->networkAccessManager();
                } else {
                    qCWarning(lcAntAsyncHasher) << "AntAsyncHasher without QmlEngine, we cannot get QNetworkAccessManager!";
                }
            }
            if (d->m_manager) {
                d->m_reply = d->m_manager->get(QNetworkRequest(source));
                connect(d->m_reply, &QNetworkReply::finished, this, [d, this]{
                    if (d->m_reply->error() == QNetworkReply::NoError) {
                        if (d->m_asynchronous) {
                            d->m_runnable = new AsyncRunnable(d->m_reply, d->m_algorithm);
                            connect(d->m_runnable, &AsyncRunnable::finished, this, &AntAsyncHasher::setHashValue, Qt::QueuedConnection);
                            connect(d->m_runnable, &AsyncRunnable::progress, this, &AntAsyncHasher::hashProgress, Qt::QueuedConnection);
                            QThreadPool::globalInstance()->start(d->m_runnable);
                        } else {
                            QCryptographicHash hash(d->m_algorithm);
                            hash.addData(d->m_reply);
                            setHashValue(hash.result().toHex().toUpper());
                            d->m_reply->deleteLater();
                        }
                    } else {
                        qCWarning(lcAntAsyncHasher) << "HTTP Request Error:" << d->m_reply->errorString();
                        d->m_reply->deleteLater();
                    }
                    d->m_reply = nullptr;
                });
            }
        }
    }
}

QString AntAsyncHasher::sourceText() const
{
    Q_D(const AntAsyncHasher);

    return d->m_sourceText;
}

void AntAsyncHasher::setSourceText(const QString &sourceText)
{
    Q_D(AntAsyncHasher);

    if (d->m_sourceText != sourceText) {
        d->m_sourceText = sourceText;
        emit sourceTextChanged();

        d->cleanupRunnable();

        emit started();
        if (d->m_asynchronous) {
            QBuffer *buffer = new QBuffer;
            buffer->setData(sourceText.toUtf8());
            buffer->open(QIODevice::ReadOnly);
            d->m_runnable = new AsyncRunnable(buffer, d->m_algorithm);
            connect(d->m_runnable, &AsyncRunnable::finished, this, &AntAsyncHasher::setHashValue, Qt::QueuedConnection);
            connect(d->m_runnable, &AsyncRunnable::progress, this, &AntAsyncHasher::hashProgress, Qt::QueuedConnection);
            QThreadPool::globalInstance()->start(d->m_runnable);
        } else {
            QCryptographicHash hash(d->m_algorithm);
            hash.addData(sourceText.toUtf8());
            setHashValue(hash.result().toHex().toUpper());
        }
    }
}

QByteArray AntAsyncHasher::sourceData() const
{
    Q_D(const AntAsyncHasher);

    return d->m_sourceData;
}

void AntAsyncHasher::setSourceData(const QByteArray &sourceData)
{
    Q_D(AntAsyncHasher);

    if (d->m_sourceData != sourceData) {
        d->m_sourceData = sourceData;
        emit sourceDataChanged();

        d->cleanupRunnable();

        emit started();
        if (d->m_asynchronous) {
            QBuffer *buffer = new QBuffer;
            buffer->setData(sourceData);
            buffer->open(QIODevice::ReadOnly);
            d->m_runnable = new AsyncRunnable(buffer, d->m_algorithm);
            connect(d->m_runnable, &AsyncRunnable::finished, this, &AntAsyncHasher::setHashValue, Qt::QueuedConnection);
            connect(d->m_runnable, &AsyncRunnable::progress, this, &AntAsyncHasher::hashProgress, Qt::QueuedConnection);
            QThreadPool::globalInstance()->start(d->m_runnable);
        } else {
            QCryptographicHash hash(d->m_algorithm);
            hash.addData(sourceData);
            setHashValue(hash.result().toHex().toUpper());
        }
    }
}

QObject *AntAsyncHasher::sourceObject() const
{
    Q_D(const AntAsyncHasher);

    return d->m_sourceObject;
}

void AntAsyncHasher::setSourceObject(QObject *sourceObject)
{
    Q_D(AntAsyncHasher);

    if (d->m_sourceObject != sourceObject) {
        d->m_sourceObject = sourceObject;
        emit sourceObjectChanged();
        emit started();
        setHashValue(QCryptographicHash::hash(QByteArray::number(qHash(sourceObject)), d->m_algorithm).toHex().toUpper());
    }
}

void AntAsyncHasher::setHashValue(const QString &value)
{
    Q_D(AntAsyncHasher);

    d->m_hashValue = value;
    emit hashValueChanged();
    emit finished();
}

bool AntAsyncHasher::operator==(const AntAsyncHasher &hasher)
{
    Q_D(const AntAsyncHasher);

    return hasher.d_func()->m_hashValue == d->m_hashValue;
}

bool AntAsyncHasher::operator!=(const AntAsyncHasher &hasher)
{
    return !(*this == hasher);
}

#include "antasynchasher.moc"
