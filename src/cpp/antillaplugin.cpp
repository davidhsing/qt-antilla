#include <QtQml/qqmlextensionplugin.h>

extern void qml_register_types_Antilla();
Q_GHS_KEEP_REFERENCE(qml_register_types_Antilla);

class AntillaPlugin : public QQmlEngineExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    AntillaPlugin(QObject *parent = nullptr) : QQmlEngineExtensionPlugin(parent)
    {
        volatile auto registration = &qml_register_types_Antilla;
        Q_UNUSED(registration);
    }
};

#include "antillaplugin.moc"
