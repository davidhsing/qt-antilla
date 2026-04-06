#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>

#ifdef BUILD_ANTILLA_STATIC_LIBRARY
#include <QtQml/qqmlextensionplugin.h>
Q_IMPORT_QML_PLUGIN(Antilla_BasicPlugin)
#endif

#include "customtheme.h"
#include "antapp.h"

int main(int argc, char *argv[])
{
    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);
    QQuickWindow::setDefaultAlphaBuffer(true);

    const QGuiApplication app(argc, argv);
    QGuiApplication::setOrganizationName("GitHub");
    QGuiApplication::setApplicationName("Antilla");
    QGuiApplication::setApplicationDisplayName("Antilla Gallery");
    QGuiApplication::setApplicationVersion(AntApp::libVersion());

    QQmlApplicationEngine engine;

    AntApp::initialize(&engine);
    CustomTheme::instance()->registerAll();

    const QUrl url = QUrl(QStringLiteral("qrc:/Gallery/qml/Gallery.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return QGuiApplication::exec();
}
