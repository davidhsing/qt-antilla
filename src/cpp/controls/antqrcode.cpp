#include "antqrcode.h"

#include "../../3rdparty/QR-Code-generator/cpp/qrcodegen.hpp"

#include <QtCore/QLoggingCategory>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkAccessManager>
#include <QtQml/QQmlEngine>
#include <QtQuick/QSGImageNode>

#include <QtQml/private/qqmlglobal_p.h>

Q_LOGGING_CATEGORY(lcAntQrCode, "antilla.basic.qrcode");

using namespace qrcodegen;

QUrl AntIconSettings::url() const
{
    return m_url;
}

void AntIconSettings::setUrl(const QUrl &url)
{
    if (m_url != url) {
        m_url = url;
        emit urlChanged();
    }
}

qreal AntIconSettings::width() const
{
    return m_width;
}

void AntIconSettings::setWidth(qreal width)
{
    if (m_width != width) {
        m_width = width;
        emit widthChanged();
    }
}

qreal AntIconSettings::height() const
{
    return m_height;
}

void AntIconSettings::setHeight(qreal height)
{
    if (m_height != height) {
        m_height = height;
        emit heightChanged();
    }
}

bool AntIconSettings::isValid() const
{
    return m_url.isValid() && m_width > 0 && m_height > 0;
}


class AntQrCodePrivate
{
public:
    AntQrCodePrivate(AntQrCode *q) : q_ptr(q) { }

    void reqIcon();
    void genQrCode();

    Q_DECLARE_PUBLIC(AntQrCode);

    AntQrCode *q_ptr = nullptr;

    QImage m_qrCodeImage;
    QString m_text;
    bool m_qrCodeChange = false;
    int m_margin = 4;
    QColor m_colorMargin = Qt::transparent;
    QColor m_color = Qt::black;
    QColor m_colorBg = Qt::transparent;
    AntQrCode::ErrorLevel m_errorLevel = AntQrCode::ErrorLevel::Medium;
    AntIconSettings *m_icon = nullptr;
    QNetworkReply *m_iconReply = nullptr;
    QImage m_cachedIcon;
};

void AntQrCodePrivate::reqIcon()
{
    Q_Q(AntQrCode);

    if (m_icon && m_icon->isValid()) {
        const auto url = m_icon->url();
        if (url.isLocalFile()) {
            m_cachedIcon = QImage(m_icon->url().toLocalFile());
            genQrCode();
        } else {
            if (!m_cachedIcon.isNull())
                m_cachedIcon = QImage();

            if (m_iconReply) {
                m_iconReply->abort();
                m_iconReply = nullptr;
            }

            if (qmlEngine(q)) {
                const auto manager = qmlEngine(q)->networkAccessManager();
                if (manager) {
                    m_iconReply = manager->get(QNetworkRequest(url));
                    QObject::connect(m_iconReply, &QNetworkReply::finished, q, [this]{
                        Q_Q(AntQrCode);
                        if (m_iconReply->error() == QNetworkReply::NoError) {
                            m_cachedIcon = QImage::fromData(m_iconReply->readAll());
                            genQrCode();
                        } else {
                            qCWarning(lcAntQrCode) << "Request icon error:" << m_iconReply->errorString();
                        }
                        m_iconReply->deleteLater();
                        m_iconReply = nullptr;
                    });
                } else {
                    qCWarning(lcAntQrCode) << "AntQrCode without QmlEngine, we cannot get QNetworkAccessManager!";
                }
            }
        }
    }
}

void AntQrCodePrivate::genQrCode()
{
    Q_Q(AntQrCode);

    const auto qr = QrCode::encodeText(m_text.toStdString().c_str(), QrCode::Ecc(m_errorLevel));

    const auto qrSize = qr.getSize();
    const auto qrMargin = qrSize + m_margin;
    const auto sourceSize = qrSize + m_margin * 2;
    m_qrCodeImage = QImage(sourceSize, sourceSize, QImage::Format_ARGB32);
    m_qrCodeImage.fill(Qt::transparent);
    for (int y = -m_margin; y < qrMargin; y++) {
        for (int x = -m_margin; x < qrMargin; x++) {
            if (x < 0 || y < 0 || x >= qrSize || y >= qrSize) {
                m_qrCodeImage.setPixelColor(x + m_margin, y + m_margin, m_colorMargin);
            } else {
                if (qr.getModule(x, y)) {
                    m_qrCodeImage.setPixelColor(x + m_margin, y + m_margin, m_color);
                } else {
                    m_qrCodeImage.setPixelColor(x + m_margin, y + m_margin, m_colorBg);
                }
            }
        }
    }

    m_qrCodeImage = m_qrCodeImage.scaled(qRound(q->width()), qRound(q->height()));

    if (m_icon && m_icon->isValid() && !m_cachedIcon.isNull()) {
        const auto iconWidth = std::min(m_qrCodeImage.width(), int(m_icon->width()));
        const auto iconHeight = std::min(m_qrCodeImage.height(), int(m_icon->height()));
        const auto icon = m_cachedIcon.scaled(iconWidth, iconHeight);
        const auto startX = (m_qrCodeImage.width() - iconWidth) / 2;
        const auto startY = (m_qrCodeImage.height() - iconHeight) / 2;
        for (int y = 0; y < iconHeight; y++) {
            for (int x = 0; x < iconWidth; x++) {
                m_qrCodeImage.setPixelColor(startX + x, startY + y, icon.pixelColor(x, y));
            }
        }
    }

    m_qrCodeChange = true;
    q->update();
}

AntQrCode::AntQrCode(QQuickItem *parent) : QQuickItem(parent), d_ptr(new AntQrCodePrivate(this))
{
    Q_D(AntQrCode);

    setFlags(QQuickItem::ItemHasContents);
    setSize({ 160, 160 });

    /*! may move to other scenes */
    connect(this, &QQuickItem::windowChanged, this, [this]{
        Q_D(AntQrCode);
        d->m_qrCodeChange = true;
        update();
    });
}

AntQrCode::~AntQrCode() = default;

QString AntQrCode::text() const
{
    Q_D(const AntQrCode);

    return d->m_text;
}

void AntQrCode::setText(const QString &text)
{
    Q_D(AntQrCode);

    if (d->m_text != text) {
        d->m_text = text;
        emit textChanged();
        d->genQrCode();
    }
}

int AntQrCode::margin() const
{
    Q_D(const AntQrCode);

    return d->m_margin;
}

void AntQrCode::setMargin(int margin)
{
    Q_D(AntQrCode);

    if (d->m_margin != margin) {
        d->m_margin = margin;
        emit marginChanged();
        d->genQrCode();
    }
}

QColor AntQrCode::color() const
{
    Q_D(const AntQrCode);

    return d->m_color;
}

void AntQrCode::setColor(const QColor &color)
{
    Q_D(AntQrCode);

    if (d->m_color != color) {
        d->m_color = color;
        emit colorChanged();
        d->genQrCode();
    }
}

QColor AntQrCode::colorMargin() const
{
    Q_D(const AntQrCode);

    return d->m_colorMargin;
}

void AntQrCode::setColorMargin(const QColor &colorMargin)
{
    Q_D(AntQrCode);

    if (d->m_colorMargin != colorMargin) {
        d->m_colorMargin = colorMargin;
        emit colorMarginChanged();
        d->genQrCode();
    }
}

QColor AntQrCode::colorBg() const
{
    Q_D(const AntQrCode);

    return d->m_colorBg;
}

void AntQrCode::setColorBg(const QColor &colorBg)
{
    Q_D(AntQrCode);

    if (d->m_colorBg != colorBg) {
        d->m_colorBg = colorBg;
        emit colorBgChanged();
        d->genQrCode();
    }
}

AntQrCode::ErrorLevel AntQrCode::errorLevel() const
{
    Q_D(const AntQrCode);

    return d->m_errorLevel;
}

void AntQrCode::setErrorLevel(AntQrCode::ErrorLevel level)
{
    Q_D(AntQrCode);

    if (d->m_errorLevel != level) {
        d->m_errorLevel = level;
        emit errorLevelChanged();
        d->genQrCode();
    }
}

AntIconSettings *AntQrCode::icon()
{
    Q_D(AntQrCode);

    if (!d->m_icon) {
        d->m_icon = new AntIconSettings;
        QQml_setParent_noEvent(d->m_icon, this);
        connect(d->m_icon, &AntIconSettings::urlChanged, this, [d]{ d->reqIcon(); });
        connect(d->m_icon, &AntIconSettings::widthChanged, this, [d]{ d->genQrCode(); });
        connect(d->m_icon, &AntIconSettings::heightChanged, this, [d]{ d->genQrCode(); });
        d->reqIcon();
    }

    return d->m_icon;
}

QSGNode *AntQrCode::updatePaintNode(QSGNode *node, UpdatePaintNodeData *)
{
    Q_D(AntQrCode);

    /*QSGSimpleTextureNode *n = static_cast<QSGSimpleTextureNode *>(node);
    if (!n) {
        n = new QSGSimpleTextureNode();
    }

    if (d->m_qrCodeChange) {
        if (window()) {
            d->m_qrCodeChange = false;
            n->setTexture(window()->createTextureFromImage(d->m_qrCodeImage, QQuickWindow::TextureHasAlphaChannel));
            n->setFiltering(QSGTexture::Linear);
            n->setOwnsTexture(true);
        }
    }

    n->setRect(boundingRect());*/

    auto *n = dynamic_cast<QSGImageNode *>(node);
    if (!n) {
        if (window()) {
            n = window()->createImageNode();
            n->setTexture(window()->createTextureFromImage(d->m_qrCodeImage, QQuickWindow::TextureHasAlphaChannel));
            n->setFiltering(QSGTexture::Linear);
            n->setOwnsTexture(true);
        }
    }

    if (n) {
        if (d->m_qrCodeChange) {
            if (window()) {
                n->setTexture(window()->createTextureFromImage(d->m_qrCodeImage, QQuickWindow::TextureHasAlphaChannel));
                d->m_qrCodeChange = false;
            }
        }
        n->setRect(boundingRect());
    }

    return n;
}
