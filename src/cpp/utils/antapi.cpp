#include "antapi.h"

#include <QtCore/QFile>
#include <QtGui/QClipboard>
#include <QtGui/QDesktopServices>
#include <QtGui/QGuiApplication>
#include <QtGui/QWindow>

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
# include <QtQml/QQmlInfo>
#endif

#include <QtQuickTemplates2/private/qquickpopup_p_p.h>

#ifdef Q_OS_WIN
# include <Windows.h>
#endif


Q_LOGGING_CATEGORY(lcAntApi, "antilla.basic.api");


AntApi::~AntApi() = default;


AntApi* AntApi::instance() {
    static auto ins = new AntApi;
    return ins;
}

AntApi* AntApi::create(QQmlEngine*, QJSEngine*) {
    return instance();
}

void AntApi::setWindowStaysOnTopHint(QWindow* window, const bool hint) {
    if (window) {
#ifdef Q_OS_WIN
        HWND hwnd = reinterpret_cast<HWND>(window->winId());
        if (hint) {
            ::SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
        } else {
            ::SetWindowPos(hwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
        }
#else
        window->setFlag(Qt::WindowStaysOnTopHint, hint);
#endif
    }
}

void AntApi::setWindowState(QWindow* window, int state) {
    if (window) {
#ifdef Q_OS_WIN
        HWND hwnd = reinterpret_cast<HWND>(window->winId());
        switch (state) {
            case Qt::WindowMinimized:
                ::ShowWindow(hwnd, SW_MINIMIZE);
                break;
            case Qt::WindowMaximized:
                ::ShowWindow(hwnd, SW_MAXIMIZE);
                break;
            default:
                window->setWindowState(Qt::WindowState(state));
                break;
        }
#else
        window->setWindowState(Qt::WindowState(state));
#endif
    }
}

void AntApi::setPopupAllowAutoFlip(QObject* popup, const bool allowVerticalFlip, const bool allowHorizontalFlip) {
    if (auto p = qobject_cast<QQuickPopup*>(popup)) {
        QQuickPopupPrivate::get(p)->allowVerticalFlip = allowVerticalFlip;
        QQuickPopupPrivate::get(p)->allowHorizontalFlip = allowHorizontalFlip;
    } else {
        qmlWarning(popup) << "Conversion to Popup failed!";
    }
}

QString AntApi::getClipboardText() {
    if (const auto clipboard = QGuiApplication::clipboard()) {
        return clipboard->text();
    }
    return QString();
}

bool AntApi::setClipboardText(const QString& text) {
    if (const auto clipboard = QGuiApplication::clipboard()) {
        clipboard->setText(text);
        return true;
    }
    return false;
}

QString AntApi::readFileToString(const QString& fileName) {
    QString result;
    if (QFile file(fileName); file.open(QIODevice::ReadOnly)) {
        result = file.readAll();
    } else {
        qCDebug(lcAntApi) << "Open file error:" << file.errorString();
    }
    return result;
}

int AntApi::getWeekNumber(const QDateTime& dateTime) {
    return dateTime.date().weekNumber();
}

QDateTime AntApi::dateFromString(const QString& dateTime, const QString& format) {
    return QDateTime::fromString(dateTime, format);
}

void AntApi::openLocalUrl(const QString& local) {
    QDesktopServices::openUrl(QUrl::fromLocalFile(local));
}

AntApi::AntApi(QObject* parent) : QObject{parent} {
}
