#pragma once
#include <QtQml/qqml.h>
#include "antglobal.h"


class ANTILLA_EXPORT HusApp : public QObject {
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(HusApp)

public:
    static void initialize(QQmlEngine* engine);

    Q_INVOKABLE static QString libVersion();

    static HusApp* instance();
    static HusApp* create(QQmlEngine*, QJSEngine*);

private:
    explicit HusApp(QObject* parent = nullptr);
};
