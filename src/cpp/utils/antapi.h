#ifndef ANTAPI_H
#define ANTAPI_H

#include <QtCore/QDate>
#include <QtQml/qqml.h>
#include <QtGui/QWindow>

#include "../antglobal.h"

class ANTILLA_EXPORT AntApi : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(AntApi)

public:
    ~AntApi();

    static AntApi *instance();
    static AntApi *create(QQmlEngine *, QJSEngine *);

    Q_INVOKABLE void setWindowStaysOnTopHint(QWindow *window, bool hint);
    Q_INVOKABLE void setWindowState(QWindow *window, int state);

    Q_INVOKABLE void setPopupAllowAutoFlip(QObject *popup, bool allowVerticalFlip = true, bool allowHorizontalFlip = true);

    Q_INVOKABLE QString getClipbordText() const;
    Q_INVOKABLE bool setClipbordText(const QString &text);

    Q_INVOKABLE QString readFileToString(const QString &fileName);

    Q_INVOKABLE int getWeekNumber(const QDateTime &dateTime) const;
    Q_INVOKABLE QDateTime dateFromString(const QString &dateTime, const QString &format) const;

    Q_INVOKABLE void openLocalUrl(const QString &local);

private:
    explicit AntApi(QObject *parent = nullptr);
};

#endif // ANTAPI_H
