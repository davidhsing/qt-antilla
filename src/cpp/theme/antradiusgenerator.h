#ifndef ANTRADIUSGENERATOR_H
#define ANTRADIUSGENERATOR_H

#include <QtCore/QObject>
#include <QtQml/qqml.h>

#include "../antglobal.h"

class ANTILLA_EXPORT AntRadiusGenerator : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(AntRadiusGenerator)

public:
    AntRadiusGenerator(QObject *parent = nullptr);
    ~AntRadiusGenerator();

    Q_INVOKABLE static QList<int> generateRadius(int radiusBase);
};

#endif // ANTRADIUSGENERATOR_H
