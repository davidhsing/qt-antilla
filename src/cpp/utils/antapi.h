#pragma once
#include <QtCore/QDate>
#include <QtQml/qqml.h>
#include <QtGui/QWindow>
#include "../antglobal.h"


class ANTILLA_EXPORT AntApi : public QObject {
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(AntApi)

public:
    ~AntApi() override;

    static AntApi* instance();
    static AntApi* create(QQmlEngine*, QJSEngine*);

    Q_INVOKABLE static void setWindowStaysOnTopHint(QWindow* window, bool hint);
    Q_INVOKABLE static void setWindowState(QWindow* window, int state);

    Q_INVOKABLE static void setPopupAllowAutoFlip(QObject* popup, bool allowVerticalFlip = true, bool allowHorizontalFlip = true);

    Q_INVOKABLE [[nodiscard]] static QString getClipboardText();
    Q_INVOKABLE static bool setClipboardText(const QString& text);

    Q_INVOKABLE static QString readFileToString(const QString& fileName);

    Q_INVOKABLE [[nodiscard]] static int getWeekNumber(const QDateTime& dateTime);
    Q_INVOKABLE [[nodiscard]] static QDateTime dateFromString(const QString& dateTime, const QString& format);

    Q_INVOKABLE static QPoint cursorPos() { return QCursor::pos(); }

    Q_INVOKABLE static void openLocalUrl(const QString& local);

private:
    explicit AntApi(QObject* parent = nullptr);
};
