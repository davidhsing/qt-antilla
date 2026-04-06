#include "antwatermark.h"
#include "anttheme.h"

#include <QtCore/QLoggingCategory>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkAccessManager>
#include <QtGui/QPainter>
#include <QtQml/QQmlEngine>

Q_LOGGING_CATEGORY(lcAntWatermark, "antilla.basic.watermark");

class AntWatermarkPrivate
{
public:
    AntWatermarkPrivate(AntWatermark *q) : q_ptr(q) { }

    void updateImage();
    void updateMarkSize();

    Q_DECLARE_PUBLIC(AntWatermark);

    AntWatermark *q_ptr = nullptr;
    QString m_text;
    QUrl m_image;
    QNetworkReply *m_imageReply = nullptr;
    QImage m_cachedImage;
    bool m_isSetMarkSize { false };
    QSize m_markSize;
    QPointF m_gap { 100, 100 };
    QPointF m_offset { 50, 50 };
    qreal m_rotate = -22;
    QFont m_font;
    QColor m_colorText { 0, 0, 0, 15 };
};

void AntWatermarkPrivate::updateImage()
{
    Q_Q(AntWatermark);

    if (m_image.isLocalFile()) {
        m_cachedImage = QImage(m_image.toLocalFile());
        updateMarkSize();
        q->update();
    } else {
        if (!m_cachedImage.isNull()) {
            m_cachedImage = QImage();
        }

        if (m_imageReply) {
            m_imageReply->abort();
            m_imageReply = nullptr;
        }

        if (qmlEngine(q)) {
            const auto manager = qmlEngine(q)->networkAccessManager();
            if (manager) {
                m_imageReply = manager->get(QNetworkRequest(m_image));
                QObject::connect(m_imageReply, &QNetworkReply::finished, q, [this]{
                    Q_Q(AntWatermark);
                    if (m_imageReply->error() == QNetworkReply::NoError) {
                        m_cachedImage = QImage::fromData(m_imageReply->readAll());
                        updateMarkSize();
                        q->update();
                    } else {
                        qCWarning(lcAntWatermark) << "Request image error:" << m_imageReply->errorString();
                    }
                    m_imageReply->deleteLater();
                    m_imageReply = nullptr;
                });
            } else {
                qCWarning(lcAntWatermark) << "AntWatermark without QmlEngine, we cannot get QNetworkAccessManager!";
            }
        }
    }
}

void AntWatermarkPrivate::updateMarkSize()
{
    if (!m_isSetMarkSize) {
        QFontMetricsF fontMetrics(m_font);
        QSizeF textSize = { fontMetrics.horizontalAdvance(m_text), fontMetrics.height() };
        int markWidth = m_cachedImage.isNull() ? textSize.width() : m_cachedImage.width();
        int markHeight = m_cachedImage.isNull() ? textSize.height() : m_cachedImage.height();
        m_markSize = { markWidth, markHeight };
    }
}

AntWatermark::AntWatermark(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , d_ptr(new AntWatermarkPrivate(this))
{
    Q_D(AntWatermark);

    d->m_font.setFamily(AntTheme::instance()->Primary()["fontPrimaryFamily"].toString());
    d->m_font.setPixelSize(AntTheme::instance()->Primary()["fontPrimarySize"].toInt());

    setAntialiasing(true);
}

AntWatermark::~AntWatermark()
{

}

QString AntWatermark::text() const
{
    Q_D(const AntWatermark);

    return d->m_text;
}

void AntWatermark::setText(const QString &text)
{
    Q_D(AntWatermark);

    if (d->m_text != text) {
        d->m_text = text;
        emit textChanged();

        d->updateMarkSize();
        update();
    }
}

QUrl AntWatermark::image() const
{
    Q_D(const AntWatermark);

    return d->m_image;
}

void AntWatermark::setImage(const QUrl &image)
{
    Q_D(AntWatermark);

    if (d->m_image != image) {
        d->m_image = image;
        emit imageChanged();

        d->updateImage();
        update();
    }
}

QSize AntWatermark::markSize() const
{
    Q_D(const AntWatermark);

    return d->m_markSize;
}

void AntWatermark::setMarkSize(const QSize &markSize)
{
    Q_D(AntWatermark);

    d->m_isSetMarkSize = true;

    if (d->m_markSize != markSize) {
        d->m_markSize = markSize;
        emit markSizeChanged();

        update();
    }
}

QPointF AntWatermark::gap() const
{
    Q_D(const AntWatermark);

    return d->m_gap;
}

void AntWatermark::setGap(const QPointF &gap)
{
    Q_D(AntWatermark);

    if (d->m_gap != gap) {
        d->m_gap = gap;
        emit gapChanged();

        update();
    }
}

QPointF AntWatermark::offset() const
{
    Q_D(const AntWatermark);

    return d->m_offset;
}

void AntWatermark::setOffset(const QPointF &offset)
{
    Q_D(AntWatermark);

    if (d->m_offset != offset) {
        d->m_offset = offset;
        emit offsetChanged();

        update();
    }
}

qreal AntWatermark::rotate() const
{
    Q_D(const AntWatermark);

    return d->m_rotate;
}

void AntWatermark::setRotate(qreal rotate)
{
    Q_D(AntWatermark);

    if (d->m_rotate != rotate) {
        d->m_rotate = rotate;
        emit rotateChanged();

        update();
    }
}

QFont AntWatermark::font() const
{
    Q_D(const AntWatermark);

    return d->m_font;
}

void AntWatermark::setFont(const QFont &font)
{
    Q_D(AntWatermark);

    if (d->m_font != font) {
        d->m_font = font;
        emit fontChanged();

        d->updateMarkSize();
        update();
    }
}

QColor AntWatermark::colorText() const
{
    Q_D(const AntWatermark);

    return d->m_colorText;
}

void AntWatermark::setColorText(const QColor &colorText)
{
    Q_D(AntWatermark);

    if (d->m_colorText != colorText) {
        d->m_colorText = colorText;
        emit colorTextChanged();
        update();
    }
}

void AntWatermark::paint(QPainter *painter)
{
    Q_D(AntWatermark);

    painter->save();

    if (antialiasing()) {
        painter->setRenderHint(QPainter::Antialiasing);
    }

    painter->setFont(d->m_font);
    painter->setPen(d->m_colorText);

    const int markWidth = d->m_markSize.width();
    const int markHeight = d->m_markSize.height();
    const int stepX = static_cast<int>(std::round(markWidth + d->m_gap.x()));
    const int stepY = static_cast<int>(std::round(markHeight + d->m_gap.y()));
    const int rowCount = static_cast<int>(std::round(width() / stepX + 1));
    const int columnCount = static_cast<int>(std::round(height() / stepY + 1));
    for (int row = 0; row < rowCount; row++) {
        for (int column = 0; column < columnCount; column++) {
            qreal x = stepX * row + d->m_offset.x() + markWidth * 0.5;
            qreal y = stepY * column + d->m_offset.y() + markHeight * 0.5;
            painter->save();
            painter->translate(x, y);
            painter->rotate(d->m_rotate);
            if (d->m_cachedImage.isNull()) {
                painter->drawText(QRectF(-markWidth * 0.5, -markHeight * 0.5, markWidth, markHeight), d->m_text);
            } else {
                painter->drawImage(QRectF(-markWidth * 0.5, -markHeight * 0.5, markWidth, markHeight), d->m_cachedImage);
            }
            painter->restore();
        }
    }
    painter->restore();
}
