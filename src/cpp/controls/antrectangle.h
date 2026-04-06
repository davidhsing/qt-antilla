#pragma once
#include <QtQuick/QQuickPaintedItem>
#include "../antglobal.h"
#include "../antdefinitions.h"


QT_FORWARD_DECLARE_CLASS(AntRectanglePrivate)


class ANTILLA_EXPORT AntRadius: public QObject {
    Q_OBJECT
    QML_NAMED_ELEMENT(AntRadius)

    Q_PROPERTY(qreal all READ all WRITE setAll NOTIFY allChanged FINAL)
    Q_PROPERTY(qreal topLeft READ topLeft WRITE setTopLeft NOTIFY topLeftChanged FINAL)
    Q_PROPERTY(qreal topRight READ topRight WRITE setTopRight NOTIFY topRightChanged FINAL)
    Q_PROPERTY(qreal bottomLeft READ bottomLeft WRITE setBottomLeft NOTIFY bottomLeftChanged FINAL)
    Q_PROPERTY(qreal bottomRight READ bottomRight WRITE setBottomRight NOTIFY bottomRightChanged FINAL)

public:
    explicit AntRadius(QObject* parent = nullptr) : QObject{parent} { }

    [[nodiscard]] qreal all() const;
    void setAll(qreal all);

    [[nodiscard]] qreal topLeft() const;
    void setTopLeft(qreal topLeft);

    [[nodiscard]] qreal topRight() const;
    void setTopRight(qreal topRight);

    [[nodiscard]] qreal bottomLeft() const;
    void setBottomLeft(qreal bottomLeft);

    [[nodiscard]] qreal bottomRight() const;
    void setBottomRight(qreal bottomRight);

signals:
    void allChanged();
    void topLeftChanged();
    void topRightChanged();
    void bottomLeftChanged();
    void bottomRightChanged();

private:
    qreal m_all = 0.;
    qreal m_topLeft = -1.;
    qreal m_topRight = -1.;
    qreal m_bottomLeft = -1.;
    qreal m_bottomRight = -1.;
};

class ANTILLA_EXPORT AntMargin: public QObject {
    Q_OBJECT
    QML_NAMED_ELEMENT(AntMargin)

    Q_PROPERTY(qreal all READ all WRITE setAll NOTIFY allChanged FINAL)
    Q_PROPERTY(qreal left READ left WRITE setLeft NOTIFY leftChanged FINAL)
    Q_PROPERTY(qreal top READ top WRITE setTop NOTIFY topChanged FINAL)
    Q_PROPERTY(qreal right READ right WRITE setRight NOTIFY rightChanged FINAL)
    Q_PROPERTY(qreal bottom READ bottom WRITE setBottom NOTIFY bottomChanged FINAL)

public:
    explicit AntMargin(QObject *parent = nullptr) : QObject{parent} { }

    [[nodiscard]] qreal all() const;
    void setAll(qreal all);

    [[nodiscard]] qreal left() const;
    void setLeft(qreal left);

    [[nodiscard]] qreal top() const;
    void setTop(qreal top);

    [[nodiscard]] qreal right() const;
    void setRight(qreal right);

    [[nodiscard]] qreal bottom() const;
    void setBottom(qreal bottom);

signals:
    void allChanged();
    void leftChanged();
    void topChanged();
    void rightChanged();
    void bottomChanged();

private:
    qreal m_all = 0.;
    qreal m_left = 0.;
    qreal m_top = 0.;
    qreal m_right = 0.;
    qreal m_bottom = 0.;
};

class ANTILLA_EXPORT AntPen: public QObject {
    Q_OBJECT
    QML_NAMED_ELEMENT(AntPen)

    ANT_PROPERTY_INIT(qreal, width, setWidth, 1)
    ANT_PROPERTY_INIT(QColor, color, setColor, Qt::transparent)
    ANT_PROPERTY_INIT(int, style, setStyle, Qt::SolidLine)

public:
    explicit AntPen(QObject *parent = nullptr) : QObject{parent} { }

    [[nodiscard]] bool isValid() const {
        return m_width > 0 && m_color.isValid() && m_color.alpha() > 0;
    }
};

class ANTILLA_EXPORT AntRectangle: public QQuickPaintedItem {
    Q_OBJECT
    QML_NAMED_ELEMENT(AntRectangle)

    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged FINAL)
    Q_PROPERTY(QJSValue gradient READ gradient WRITE setGradient RESET resetGradient)
    Q_PROPERTY(AntPen* border READ border CONSTANT)

    Q_PROPERTY(qreal radius READ radius WRITE setRadius NOTIFY radiusChanged FINAL)
    Q_PROPERTY(qreal topLeftRadius READ topLeftRadius WRITE setTopLeftRadius NOTIFY topLeftRadiusChanged FINAL)
    Q_PROPERTY(qreal topRightRadius READ topRightRadius WRITE setTopRightRadius NOTIFY topRightRadiusChanged FINAL)
    Q_PROPERTY(qreal bottomLeftRadius READ bottomLeftRadius WRITE setBottomLeftRadius NOTIFY bottomLeftRadiusChanged FINAL)
    Q_PROPERTY(qreal bottomRightRadius READ bottomRightRadius WRITE setBottomRightRadius NOTIFY bottomRightRadiusChanged FINAL)

public:
    explicit AntRectangle(QQuickItem *parent = nullptr);

    [[nodiscard]] QColor color() const;
    void setColor(QColor color);

    AntPen *border();

    [[nodiscard]] QJSValue gradient() const;
    void setGradient(const QJSValue &gradient);
    void resetGradient();

    [[nodiscard]] qreal radius() const;
    void setRadius(qreal radius);

    [[nodiscard]] qreal topLeftRadius() const;
    void setTopLeftRadius(qreal radius);

    [[nodiscard]] qreal topRightRadius() const;
    void setTopRightRadius(qreal radius);

    [[nodiscard]] qreal bottomLeftRadius() const;
    void setBottomLeftRadius(qreal radius);

    [[nodiscard]] qreal bottomRightRadius() const;
    void setBottomRightRadius(qreal radius);

signals:
    void colorChanged();
    void radiusChanged();
    void topLeftRadiusChanged();
    void topRightRadiusChanged();
    void bottomLeftRadiusChanged();
    void bottomRightRadiusChanged();

protected:
    void paint(QPainter *painter) override;

private Q_SLOTS:
    void doUpdate();

private:
    Q_DECLARE_PRIVATE(AntRectangle);
    QSharedPointer<AntRectanglePrivate> d_ptr;
};

#if QT_VERSION >= QT_VERSION_CHECK(6, 7, 0)
# include <private/qquickrectangle_p.h>

/*! 内部矩形, 作为高版本基础控件时在内部使用, 但无法使用 border.style */
class AntRectangleInternal: public QQuickRectangle {
    Q_OBJECT
    QML_NAMED_ELEMENT(AntRectangleInternal)

public:
    explicit AntRectangleInternal(QQuickItem *parent = nullptr) : QQuickRectangle{parent} { }
};

#else

class AntRectangleInternal: public AntRectangle {
    Q_OBJECT
    QML_NAMED_ELEMENT(AntRectangleInternal)

public:
    explicit AntRectangleInternal(QQuickItem *parent = nullptr) : AntRectangle{parent} { }
    ~AntRectangleInternal() { };
};

#endif
