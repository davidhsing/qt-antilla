#include "anticonfont.h"

AntIcon::AntIcon(QObject* parent) : QObject{parent} {
}

AntIcon *AntIcon::instance() {
    static AntIcon *ins = new AntIcon;
    return ins;
}

AntIcon *AntIcon::create(QQmlEngine*, QJSEngine*) {
    return instance();
}

QVariantMap AntIcon::allIconNames() {
    QVariantMap iconMap;
    QMetaEnum me = QMetaEnum::fromType<AntIcon::Type>();
    for (int i = 0; i < me.keyCount(); i++) {
        iconMap[QString::fromLatin1(me.key(i))] = me.value(i);
    }
    return iconMap;
}
