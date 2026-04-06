#ifndef ANTSIZEGENERATOR_H
#define ANTSIZEGENERATOR_H

#include <QtCore/QObject>
#include <QtQml/qqml.h>

#include "../antglobal.h"

class ANTILLA_EXPORT AntSizeGenerator : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(AntSizeGenerator)

public:
    explicit AntSizeGenerator(QObject *parent = nullptr);

    Q_INVOKABLE static QList<qreal> generateFontSize(qreal fontSizeBase);
    Q_INVOKABLE static QList<qreal> generateFontLineHeight(qreal fontSizeBase);
};

#endif // ANTSIZEGENERATOR_H
