#ifndef CORE_H_
#define CORE_H_

#include <QJsonArray>
#include <QObject>
#include <QString>
#include <QtQml>

class Core : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    Q_INVOKABLE bool login(const QString &username);
    Q_INVOKABLE QJsonArray rooms();

private:
    // TODO preferably a QStringView
    const char *_serverUrl { "http://localhost:8080" };
    QString _userIdentifier;
};

#endif // CORE_H_
