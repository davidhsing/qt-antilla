#ifndef ANTCOLORGENERATOR_H
#define ANTCOLORGENERATOR_H

#include <QtCore/QObject>
#include <QtGui/QColor>
#include <QtQml/qqml.h>

#include "../antglobal.h"

class ANTILLA_EXPORT AntColorGenerator : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(AntColorGenerator)

public:
    enum class Preset
    {
        Preset_Red = 1,
        Preset_Volcano,
        Preset_Orange,
        Preset_Gold,
        Preset_Yellow,
        Preset_Lime,
        Preset_Green,
        Preset_Cyan,
        Preset_Blue,
        Preset_Geekblue,
        Preset_Purple,
        Preset_Magenta,
        Preset_Grey
    };
    Q_ENUM(Preset);

    explicit AntColorGenerator(QObject* parent = nullptr);

    Q_INVOKABLE static QColor reverseColor(const QColor &color);
    Q_INVOKABLE static QColor presetToColor(const QString& color);
    Q_INVOKABLE static QColor presetToColor(AntColorGenerator::Preset color);
    Q_INVOKABLE static QList<QColor> generate(AntColorGenerator::Preset color, bool light = true, const QColor &background = QColor(QColor::Invalid));
    Q_INVOKABLE static QList<QColor> generate(const QColor &color, bool light = true, const QColor &background = QColor(QColor::Invalid));
};


#endif // ANTCOLORGENERATOR_H
