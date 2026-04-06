#include "antrectangle.h"

#include <QtGui/QLinearGradient>
#include <QtGui/QPainter>
#include <QtGui/QPainterPath>
#include <QtQml/QQmlInfo>

#include <private/qqmlmetatype_p.h>
#include <private/qqmlglobal_p.h>
#include <private/qquickrectangle_p.h>

qreal AntRadius::all() const {
    return m_all;
}

void AntRadius::setAll(const qreal all) {
    if (m_all == all) {
        return;
    }
    m_all = all;
    emit allChanged();
    // Set all if it is negative
    if (m_topLeft < 0.) {
        emit topLeftChanged();
    }
    if (m_topRight < 0.) {
        emit topRightChanged();
    }
    if (m_bottomLeft < 0.) {
        emit bottomLeftChanged();
    }
    if (m_bottomRight < 0.) {
        emit bottomRightChanged();
    }
}

qreal AntRadius::topLeft() const {
    if (m_topLeft >= 0.) {
        return m_topLeft;
    }
    return m_all;
}

void AntRadius::setTopLeft(const qreal topLeft) {
    if (m_topLeft == topLeft) {
        return;
    }
    if (topLeft < 0) {
        qmlWarning(this) << "topLeftRadius (" << topLeft << ") cannot be less than 0.";
        return;
    }
    m_topLeft = topLeft;
    emit topLeftChanged();
}

qreal AntRadius::topRight() const {
    if (m_topRight >= 0.) {
        return m_topRight;
    }
    return m_all;
}

void AntRadius::setTopRight(const qreal topRight) {
    if (m_topRight == topRight) {
        return;
    }
    if (topRight < 0) {
        qmlWarning(this) << "topRightRadius (" << topRight << ") cannot be less than 0.";
        return;
    }
    m_topRight = topRight;
    emit topRightChanged();
}

qreal AntRadius::bottomLeft() const {
    if (m_bottomLeft >= 0.) {
        return m_bottomLeft;
    }
    return m_all;
}

void AntRadius::setBottomLeft(const qreal bottomLeft) {
    if (m_bottomLeft == bottomLeft) {
        return;
    }
    if (bottomLeft < 0) {
        qmlWarning(this) << "bottomLeftRadius (" << bottomLeft << ") cannot be less than 0.";
        return;
    }
    m_bottomLeft = bottomLeft;
    emit bottomLeftChanged();
}

qreal AntRadius::bottomRight() const {
    if (m_bottomRight >= 0.) {
        return m_bottomRight;
    }
    return m_all;
}

void AntRadius::setBottomRight(const qreal bottomRight) {
    if (m_bottomRight == bottomRight) {
        return;
    }
    if (bottomRight < 0) {
        qmlWarning(this) << "bottomRightRadius (" << bottomRight << ") cannot be less than 0.";
        return;
    }
    m_bottomRight = bottomRight;
    emit bottomRightChanged();
}

qreal AntMargin::all() const {
    return m_all;
}

void AntMargin::setAll(const qreal all) {
    if (m_all == all) {
        return;
    }
    m_all = all;
    emit allChanged();
    // Set all if it is negative
    if (m_top < 0.) {
        emit topChanged();
    }
    if (m_bottom < 0.) {
        emit bottomChanged();
    }
    if (m_left < 0.) {
        emit leftChanged();
    }
    if (m_right < 0.) {
        emit rightChanged();
    }
}

qreal AntMargin::left() const {
    if (m_left >= 0.) {
        return m_left;
    }
    return m_all;
}

void AntMargin::setLeft(const qreal left) {
    if (m_left == left) {
        return;
    }
    if (left < 0) {
        qmlWarning(this) << "left (" << left << ") cannot be less than 0.";
        return;
    }
    m_left = left;
    emit leftChanged();
}

qreal AntMargin::top() const {
    if (m_top >= 0.) {
        return m_top;
    }
    return m_all;
}

void AntMargin::setTop(const qreal top) {
    if (m_top == top) {
        return;
    }
    if (top < 0) {
        qmlWarning(this) << "top (" << top << ") cannot be less than 0.";
        return;
    }
    m_top = top;
    emit topChanged();
}

qreal AntMargin::right() const {
    if (m_right >= 0.) {
        return m_right;
    }
    return m_all;
}

void AntMargin::setRight(const qreal right) {
    if (m_right == right) {
        return;
    }
    if (right < 0) {
        qmlWarning(this) << "right (" << right << ") cannot be less than 0.";
        return;
    }
    m_right = right;
    emit rightChanged();
}

qreal AntMargin::bottom() const {
    if (m_bottom >= 0.) {
        return m_bottom;
    }
    return m_all;
}

void AntMargin::setBottom(const qreal bottom) {
    if (m_bottom == bottom) {
        return;
    }
    if (bottom < 0) {
        qmlWarning(this) << "bottom (" << bottom << ") cannot be less than 0.";
        return;
    }
    m_bottom = bottom;
    emit bottomChanged();
}

class AntRectanglePrivate {
public:
    QColor m_color = { 0xffffff };
    AntPen *m_pen = nullptr;
    QJSValue m_gradient;
    qreal m_radius = 0;
    qreal m_topLeftRadius = 0;
    qreal m_topRightRadius = 0;
    qreal m_bottomLeftRadius = 0;
    qreal m_bottomRightRadius = 0;

    static int doUpdateSlotIdx;
};

int AntRectanglePrivate::doUpdateSlotIdx = -1;

AntRectangle::AntRectangle(QQuickItem* parent) : QQuickPaintedItem{parent}, d_ptr(new AntRectanglePrivate) {
}

QColor AntRectangle::color() const {
    Q_D(const AntRectangle);
    return d->m_color;
}

void AntRectangle::setColor(const QColor color) {
    Q_D(AntRectangle);
    if (d->m_color != color) {
        d->m_color = color;
        emit colorChanged();
        update();
    }
}

AntPen *AntRectangle::border() {
    Q_D(AntRectangle);
    if (!d->m_pen) {
        d->m_pen = new AntPen;
        QQml_setParent_noEvent(d->m_pen, this);
        connect(d->m_pen, &AntPen::colorChanged, this, [this]{ update(); });
        connect(d->m_pen, &AntPen::widthChanged, this, [this]{ update(); });
        connect(d->m_pen, &AntPen::styleChanged, this, [this]{ update(); });
        update();
    }
    return d->m_pen;
}

QJSValue AntRectangle::gradient() const {
    Q_D(const AntRectangle);
    return d->m_gradient;
}

void AntRectangle::setGradient(const QJSValue &gradient) {
    Q_D(AntRectangle);
    if (d->m_gradient.equals(gradient)) {
        return;
    }
    static int updatedSignalIdx = QMetaMethod::fromSignal(&QQuickGradient::updated).methodIndex();
    if (AntRectanglePrivate::doUpdateSlotIdx < 0) {
        AntRectanglePrivate::doUpdateSlotIdx = QQuickRectangle::staticMetaObject.indexOfSlot("doUpdate()");
    }
    if (const auto oldGradient = qobject_cast<QQuickGradient*>(d->m_gradient.toQObject())) {
        QMetaObject::disconnect(oldGradient, updatedSignalIdx, this, d->doUpdateSlotIdx);
    }
    if (gradient.isQObject()) {
        if (const auto newGradient = qobject_cast<QQuickGradient*>(gradient.toQObject())) {
            d->m_gradient = gradient;
            QMetaObject::connect(newGradient, updatedSignalIdx, this, d->doUpdateSlotIdx);
        } else {
            qmlWarning(this) << "Can't assign "
                             << QQmlMetaType::prettyTypeName(gradient.toQObject()) << " to gradient property.";
            d->m_gradient = QJSValue();
        }
    } else if (gradient.isNumber() || gradient.isString()) {
        static const QMetaEnum gradientPresetMetaEnum = QMetaEnum::fromType<QGradient::Preset>();
        Q_ASSERT(gradientPresetMetaEnum.isValid());
        QGradient result;
        if (gradient.isNumber()) {
            const auto preset = QGradient::Preset(gradient.toInt());
            if (preset != QGradient::NumPresets && gradientPresetMetaEnum.valueToKey(preset)) {
                result = QGradient(preset);
            }
        } else if (gradient.isString()) {
            const auto presetName = gradient.toString();
            if (presetName != QLatin1String("NumPresets")) {
                bool ok;
                const auto presetInt = gradientPresetMetaEnum.keyToValue(qPrintable(presetName), &ok);
                if (ok) {
                    result = QGradient(QGradient::Preset(presetInt));
                }
            }
        }
        if (result.type() != QGradient::NoGradient) {
            d->m_gradient = gradient;
        } else {
            qmlWarning(this) << "No such gradient preset '" << gradient.toString() << "'.";
            d->m_gradient = QJSValue();
        }
    } else if (gradient.isNull() || gradient.isUndefined()) {
        d->m_gradient = gradient;
    } else {
        qmlWarning(this) << "Unknown gradient type. Expected int, string, or Gradient.";
        d->m_gradient = QJSValue();
    }
    update();
}

void AntRectangle::resetGradient() {
    setGradient(QJSValue());
}

qreal AntRectangle::radius() const {
    Q_D(const AntRectangle);
    return d->m_radius;
}

void AntRectangle::setRadius(const qreal radius) {
    Q_D(AntRectangle);
    if (d->m_radius == radius) {
        return;
    }
    d->m_radius = radius;
    emit radiusChanged();
    setTopLeftRadius(radius);
    setTopRightRadius(radius);
    setBottomLeftRadius(radius);
    setBottomRightRadius(radius);
    update();
}

qreal AntRectangle::topLeftRadius() const {
    Q_D(const AntRectangle);
    if (d->m_topLeftRadius >= 0.) {
        return d->m_topLeftRadius;
    }
    return d->m_radius;
}

void AntRectangle::setTopLeftRadius(const qreal radius) {
    Q_D(AntRectangle);
    if (d->m_topLeftRadius == radius) {
        return;
    }
    if (radius < 0) {
        qmlWarning(this) << "topLeftRadius (" << radius << ") cannot be less than 0.";
        return;
    }
    d->m_topLeftRadius = radius;
    emit topLeftRadiusChanged();
    update();
}

qreal AntRectangle::topRightRadius() const {
    Q_D(const AntRectangle);
    if (d->m_topRightRadius >= 0.) {
        return d->m_topRightRadius;
    }
    return d->m_radius;
}

void AntRectangle::setTopRightRadius(const qreal radius) {
    Q_D(AntRectangle);
    if (d->m_topRightRadius == radius) {
        return;
    }
    if (radius < 0) {
        qmlWarning(this) << "topRightRadius (" << radius << ") cannot be less than 0.";
        return;
    }
    d->m_topRightRadius = radius;
    emit topRightRadiusChanged();
    update();
}

qreal AntRectangle::bottomLeftRadius() const {
    Q_D(const AntRectangle);
    if (d->m_bottomLeftRadius >= 0.) {
        return d->m_bottomLeftRadius;
    }
    return d->m_radius;
}

void AntRectangle::setBottomLeftRadius(const qreal radius) {
    Q_D(AntRectangle);
    if (d->m_bottomLeftRadius == radius) {
        return;
    }
    if (radius < 0) {
        qmlWarning(this) << "bottomLeftRadius (" << radius << ") cannot be less than 0.";
        return;
    }
    d->m_bottomLeftRadius = radius;
    emit bottomLeftRadiusChanged();
    update();
}

qreal AntRectangle::bottomRightRadius() const {
    Q_D(const AntRectangle);
    if (d->m_bottomRightRadius >= 0.) {
        return d->m_bottomRightRadius;
    }
    return d->m_radius;
}

void AntRectangle::setBottomRightRadius(const qreal radius) {
    Q_D(AntRectangle);
    if (d->m_bottomRightRadius == radius) {
        return;
    }
    if (radius < 0) {
        qmlWarning(this) << "bottomRightRadius (" << radius << ") cannot be less than 0.";
        return;
    }
    d->m_bottomRightRadius = radius;
    emit bottomRightRadiusChanged();
    update();
}

void AntRectangle::paint(QPainter* painter) {
    Q_D(AntRectangle);
    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);
    auto rect = boundingRect();
    if (d->m_pen && d->m_pen->isValid()) {
        rect = boundingRect();
        if (rect.width() > d->m_pen->width() * 2) {
            auto dx = d->m_pen->width() / 2;
            rect.adjust(dx, 0, -dx, 0);
        }
        if (rect.height() > d->m_pen->width() * 2) {
            auto dy = d->m_pen->width() / 2;
            rect.adjust(0, dy, 0, -dy);
        }
        painter->setPen(QPen(d->m_pen->color(), d->m_pen->width(), Qt::PenStyle(d->m_pen->style()), Qt::SquareCap, Qt::SvgMiterJoin));
    } else {
        painter->setPen(QPen(Qt::transparent));
    }
    const auto maxRadius = height() / 2;
    const auto topLeftRadius = std::min(d->m_topLeftRadius, maxRadius);
    const auto topRightRadius = std::min(d->m_topRightRadius, maxRadius);
    const auto bottomLeftRadius = std::min(d->m_bottomLeftRadius, maxRadius);
    const auto bottomRightRadius = std::min(d->m_bottomRightRadius, maxRadius);
    QPainterPath path;
    path.moveTo(rect.bottomRight() - QPointF(0, bottomRightRadius));
    path.lineTo(rect.topRight() + QPointF(0, topRightRadius));
    path.arcTo(QRectF(QPointF(rect.topRight() - QPointF(topRightRadius * 2, 0)),
                      QSize(topRightRadius * 2, topRightRadius * 2)), 0, 90);
    path.lineTo(rect.topLeft() + QPointF(topLeftRadius, 0));
    path.arcTo(QRectF(QPointF(rect.topLeft()), QSize(topLeftRadius * 2, topLeftRadius * 2)), 90, 90);
    path.lineTo(rect.bottomLeft() - QPointF(0, bottomLeftRadius));
    path.arcTo(QRectF(QPointF(rect.bottomLeft().x(), rect.bottomLeft().y() - bottomLeftRadius * 2),
                      QSize(bottomLeftRadius * 2, bottomLeftRadius * 2)), 180, 90);
    path.lineTo(rect.bottomRight() - QPointF(bottomRightRadius, 0));
    path.arcTo(QRectF(QPointF(rect.bottomRight() - QPointF(bottomRightRadius * 2, bottomRightRadius * 2)),
                      QSize(bottomRightRadius * 2, bottomRightRadius * 2)), 270, 90);
    /*! 绘制渐变 */
    QGradientStops stops;
    bool vertical = true;
    if (d->m_gradient.isQObject()) {
        auto gradient = qobject_cast<QQuickGradient*>(d->m_gradient.toQObject());
        Q_ASSERT(gradient);
        stops = gradient->gradientStops();
        vertical = gradient->orientation() == QQuickGradient::Vertical;
    } else if (d->m_gradient.isNumber() || d->m_gradient.isString()) {
        QGradient preset(d->m_gradient.toVariant().value<QGradient::Preset>());
        if (preset.type() == QGradient::LinearGradient) {
            auto linearGradient = static_cast<QLinearGradient&>(preset);
            const QPointF start = linearGradient.start();
            const QPointF end = linearGradient.finalStop();
            vertical = qAbs(start.y() - end.y()) >= qAbs(start.x() - end.x());
            stops = linearGradient.stops();
            if ((vertical && start.y() > end.y()) || (!vertical && start.x() > end.x())) {
                QGradientStops reverseStops;
                for (auto it = stops.rbegin(); it != stops.rend(); ++it) {
                    auto stop = *it;
                    stop.first = 1 - stop.first;
                    reverseStops.append(stop);
                }
                stops = reverseStops;
            }
        }
    }
    if (stops.isEmpty()) {
        painter->setBrush(d->m_color);
    } else {
        float gradientStart = vertical ? rect.top() : rect.left();
        float gradientLength = vertical ? rect.height() : rect.width();
        float secondaryLength = vertical ? rect.width() : rect.height();
        QLinearGradient gradient(vertical ? QPointF{ gradientStart, 0 } : QPointF{ 0, secondaryLength },
                                 vertical ? QPointF{ gradientStart, gradientLength } : QPointF{ gradientLength, secondaryLength });
        gradient.setStops(stops);
        painter->setBrush(gradient);
    }
    painter->drawPath(path);
    painter->restore();
}

void AntRectangle::doUpdate() {
    update();
}
