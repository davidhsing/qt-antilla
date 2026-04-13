#pragma once
#include <QtCore/QObject>
#include <QtQml/qqml.h>
#include "../antglobal.h"


#ifdef BUILD_ANTILLA_DESKTOP_PLATFORM
#include <QWKQuick/quickwindowagent.h>
#endif


#ifdef BUILD_ANTILLA_DESKTOP_PLATFORM
class ANTILLA_EXPORT AntWindowAgent : public QWK::QuickWindowAgent, public QQmlParserStatus
#else
class ANTILLA_EXPORT AntWindowAgent : public QObject, public QQmlParserStatus
#endif
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    QML_NAMED_ELEMENT(AntWindowAgent)

public:
    explicit AntWindowAgent(QObject *parent = nullptr);

    void classBegin() override;
    void componentComplete() override;

#ifdef BUILD_ANTILLA_DESKTOP_PLATFORM
    // Install a native event filter for system-wide shortcut blocking
    Q_INVOKABLE void installNativeEventFilter(QObject *filter) const;
    // Remove a native event filter
    Q_INVOKABLE void removeNativeEventFilter(QObject *filter) const;
#endif
};
