#include "antthemefunctions.h"
#include "antcolorgenerator.h"
#include "antsizegenerator.h"
#include "antradiusgenerator.h"

#include <QtGui/QFontDatabase>

AntThemeFunctions::AntThemeFunctions(QObject *parent) : QObject{parent}
{
}

AntThemeFunctions *AntThemeFunctions::instance()
{
    static AntThemeFunctions *ins = new AntThemeFunctions;
    return ins;
}

AntThemeFunctions *AntThemeFunctions::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

QList<QColor> AntThemeFunctions::genColor(int preset, bool light, const QColor &background)
{
    return AntColorGenerator::generate(AntColorGenerator::Preset(preset), light, background);
}

QList<QColor> AntThemeFunctions::genColor(const QColor &color, bool light, const QColor &background)
{
    return AntColorGenerator::generate(color, light, background);
}

QList<QString> AntThemeFunctions::genColorString(const QColor &color, bool light, const QColor &background)
{
    QList<QString> result;
    const auto listColor = AntColorGenerator::generate(color, light, background);
    for (const auto &color: listColor)
        result.append(color.name());

    return result;
}

QList<qreal> AntThemeFunctions::genFontSize(qreal fontSizeBase)
{
    return AntSizeGenerator::generateFontSize(fontSizeBase);
}

QList<qreal> AntThemeFunctions::genFontLineHeight(qreal fontSizeBase)
{
    return AntSizeGenerator::generateFontLineHeight(fontSizeBase);
}

QList<int> AntThemeFunctions::genRadius(int radiusBase)
{
    return AntRadiusGenerator::generateRadius(radiusBase);
}

QString AntThemeFunctions::genFontFamily(const QString &familyBase)
{
    const auto families = familyBase.split(',');
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    const auto database = QFontDatabase::families();
#else
    const auto database = QFontDatabase().families();
#endif
    for(auto family: families) {
        auto normalize = family.remove('\'').remove('\"').trimmed();
        if (database.contains(normalize)) {
            return normalize.trimmed();
        }
    }
    return database.first();
}

QColor AntThemeFunctions::darker(const QColor &color, int factor)
{
    return color.darker(factor);
}

QColor AntThemeFunctions::lighter(const QColor &color, int factor)
{
    return color.lighter(factor);
}

QColor AntThemeFunctions::alpha(const QColor &color, qreal alpha)
{
    return QColor(color.red(), color.green(), color.blue(), alpha * 255);
}

QColor AntThemeFunctions::onBackground(const QColor &color, const QColor &background)
{
    const auto fg = color.toRgb();
    const auto bg = background.toRgb();
    const auto alpha = fg.alphaF() + bg.alphaF() * (1 - fg.alphaF());

    return QColor::fromRgbF(
            fg.redF() * fg.alphaF() + bg.redF() * bg.alphaF() * (1 - fg.alphaF()) / alpha,
            fg.greenF() * fg.alphaF() + bg.greenF() * bg.alphaF() * (1 - fg.alphaF()) / alpha,
            fg.blueF() * fg.alphaF() + bg.blueF() * bg.alphaF() * (1 - fg.alphaF()) / alpha,
            alpha
        );
}

qreal AntThemeFunctions::add(qreal num1, qreal num2)
{
    return num1 + num2;
}

qreal AntThemeFunctions::subtract(qreal num1, qreal num2)
{
    return num1 - num2;
}

qreal AntThemeFunctions::multiply(qreal num1, qreal num2)
{
    return num1 * num2;
}

qreal AntThemeFunctions::divide(qreal num1, qreal num2)
{
    return (num2 == 0) ? 0 : (num1 / num2);
}
