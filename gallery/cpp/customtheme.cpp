#include "customtheme.h"
#include "anttheme.h"

CustomTheme *CustomTheme::instance()
{
    static CustomTheme *ins = new CustomTheme;
    return ins;
}

CustomTheme *CustomTheme::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

void CustomTheme::registerAll()
{
    /*AntTheme::instance()->registerCustomComponentTheme(this, "MyControl", &m_MyControl, ":/Gallery/theme/MyControl.json");
    AntTheme::instance()->reloadTheme();*/
}

CustomTheme::CustomTheme(QObject *parent)
    : QObject{parent}
{

}
