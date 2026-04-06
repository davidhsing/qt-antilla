#pragma once
#include <QtQuick/QQuickPaintedItem>
#include "../antglobal.h"


QT_FORWARD_DECLARE_CLASS(AntQrCodePrivate);


class ANTILLA_EXPORT AntIconSettings : public QObject {
    Q_OBJECT

    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged FINAL)
    Q_PROPERTY(qreal width READ width WRITE setWidth NOTIFY widthChanged FINAL)
    Q_PROPERTY(qreal height READ height WRITE setHeight NOTIFY heightChanged FINAL)

    QML_NAMED_ELEMENT(AntIconSettings)

public:
    explicit AntIconSettings(QObject *parent = nullptr) : QObject{parent} { }

    [[nodiscard]] QUrl url() const;
    void setUrl(const QUrl &url);

    [[nodiscard]] qreal width() const;
    void setWidth(qreal width);

    [[nodiscard]] qreal height() const;
    void setHeight(qreal height);

    [[nodiscard]] bool isValid() const;

signals:
    void urlChanged();
    void widthChanged();
    void heightChanged();

private:
    QUrl m_url;
    qreal m_width = 40;
    qreal m_height = 40;
};

class ANTILLA_EXPORT AntQrCode : public QQuickItem {
    Q_OBJECT

    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged FINAL)
    Q_PROPERTY(int margin READ margin WRITE setMargin NOTIFY marginChanged FINAL)
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged FINAL)
    Q_PROPERTY(QColor colorMargin READ colorMargin WRITE setColorMargin NOTIFY colorMarginChanged FINAL)
    Q_PROPERTY(QColor colorBg READ colorBg WRITE setColorBg NOTIFY colorBgChanged FINAL)
    Q_PROPERTY(AntQrCode::ErrorLevel errorLevel READ errorLevel WRITE setErrorLevel NOTIFY errorLevelChanged FINAL)
    Q_PROPERTY(AntIconSettings* icon READ icon CONSTANT)

    QML_NAMED_ELEMENT(AntQrCode)

public:
    enum class ErrorLevel : uint8_t {
        Low = 0 ,  // The QR Code can tolerate about  7% erroneous codewords
        Medium  ,  // The QR Code can tolerate about 15% erroneous codewords
        Quartile,  // The QR Code can tolerate about 25% erroneous codewords
        High       // The QR Code can tolerate about 30% erroneous codewords
    };
    Q_ENUM(ErrorLevel);

    AntQrCode(QQuickItem *parent = nullptr);
    ~AntQrCode() override;

    [[nodiscard]] QString text() const;
    void setText(const QString &text);

    [[nodiscard]] int margin() const;
    void setMargin(int margin);

    [[nodiscard]] QColor color() const;
    void setColor(const QColor &color);

    [[nodiscard]] QColor colorMargin() const;
    void setColorMargin(const QColor &colorMargin);

    [[nodiscard]] QColor colorBg() const;
    void setColorBg(const QColor &colorBg);

    [[nodiscard]] AntQrCode::ErrorLevel errorLevel() const;
    void setErrorLevel(AntQrCode::ErrorLevel level);

    AntIconSettings *icon();

protected:
    QSGNode *updatePaintNode(QSGNode *node, UpdatePaintNodeData *) override;

signals:
    void textChanged();
    void marginChanged();
    void colorChanged();
    void colorMarginChanged();
    void colorBgChanged();
    void errorLevelChanged();

private:
    Q_DECLARE_PRIVATE(AntQrCode);
    QScopedPointer<AntQrCodePrivate> d_ptr;
};
