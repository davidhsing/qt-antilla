#include "antwindowagent.h"

#ifdef BUILD_ANTILLA_DESKTOP_PLATFORM
#include <QWKCore/private/windowagentbase_p.h>
#include <QWKCore/private/nativeeventfilter_p.h>
#endif


AntWindowAgent::AntWindowAgent(QObject* parent)
#ifdef BUILD_ANTILLA_DESKTOP_PLATFORM
    : QWK::QuickWindowAgent{parent}
#else
    : QObject{parent}
#endif
{
}

void AntWindowAgent::classBegin() {
    auto p = parent();
    Q_ASSERT_X(p, "AntWindowAgent", "parent() return nullptr!");
    if (p) {
#ifdef BUILD_ANTILLA_DESKTOP_PLATFORM
# if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
        if (p->objectName() == QLatin1StringView("__AntWindow__")) {
            setup(qobject_cast<QQuickWindow *>(p));
        }
# else
        if (p->objectName() == QLatin1String("__AntWindow__")) {
            setup(qobject_cast<QQuickWindow *>(p));
        }
# endif
#endif
    }
}

void AntWindowAgent::componentComplete() {
}

#ifdef BUILD_ANTILLA_DESKTOP_PLATFORM

void AntWindowAgent::installNativeEventFilter(QObject* filter) const {
    if (!filter) {
        return;
    }
    // Access private QWindowKit API to install native event filter
    auto* d_ptr = QuickWindowAgent::d_ptr.get();
    if (d_ptr && d_ptr->context && dynamic_cast<QWK::NativeEventFilter*>(filter)) {
        d_ptr->context->installNativeEventFilter(dynamic_cast<QWK::NativeEventFilter*>(filter));
    }
}

void AntWindowAgent::removeNativeEventFilter(QObject* filter) const {
    if (!filter) {
        return;
    }
    // Access private QWindowKit API to remove native event filter
    if (auto* d_ptr = QuickWindowAgent::d_ptr.get(); d_ptr && d_ptr->context && dynamic_cast<QWK::NativeEventFilter*>(filter)) {
        d_ptr->context->removeNativeEventFilter(dynamic_cast<QWK::NativeEventFilter*>(filter));
    }
}

#endif
