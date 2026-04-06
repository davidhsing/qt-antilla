#pragma once
#include <QtQml/qqml.h>
#include "antglobal.h"


class ANTILLA_EXPORT AntApp : public QObject {
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(AntApp)

public:
    static void initialize(QQmlEngine* engine);

    Q_INVOKABLE static QString libVersion();

    static AntApp* instance();
    static AntApp* create(QQmlEngine*, QJSEngine*);

private:
    explicit AntApp(QObject* parent = nullptr);
};
