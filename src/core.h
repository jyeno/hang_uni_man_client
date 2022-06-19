#ifndef CORE_H_
#define CORE_H_

// TODO possibility have a qqmlpropertymap that is going to be updated everytime .data is received

#include <QJsonArray>
#include <QObject>
#include <QString>
#include <QtQml>

class QTcpSocket;
class QQmlPropertyMap;

class Core : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlPropertyMap *data MEMBER _data NOTIFY dataChanged)
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit Core(QObject *parent = nullptr);

    enum class PlayModality { Solo, Multiplayer };
    Q_ENUM(PlayModality)

    Q_INVOKABLE void login(const QString &username);
    Q_INVOKABLE void logout();
    Q_INVOKABLE void resetData();

    Q_INVOKABLE void createRoom(const QString &roomName, const QString &difficulty);
    Q_INVOKABLE void rooms();
    Q_INVOKABLE void joinRoom(const QString &roomUid);
    Q_INVOKABLE void kickPlayerRoom(int indexPlayer);
    Q_INVOKABLE void exitRoom();
    Q_INVOKABLE void sendRoomMessage(const QString &message);

    Q_INVOKABLE void startGame(PlayModality modality);
    Q_INVOKABLE void exitGame();
    Q_INVOKABLE void gameGuessLetter(const QChar guessed);
    Q_INVOKABLE void gameGuessWord(const QString &guessed);

Q_SIGNALS:
    void playerCreated(const QString &name);
    void roomListChanged(const QJsonArray &array);
    void gameStarted(const QJsonObject &metadata);
    void gameChanged(const QJsonObject &metadata);
    void gameFinished(const QJsonObject &metadata);
    void roomCreated(const QJsonObject &metadata);
    void roomChanged(const QJsonObject &metadata);
    void roomMessageReceived(const QJsonObject &metadata);
    void playerEliminated();
    void dataChanged(const QQmlPropertyMap *map);
    void errorHappened(const QString &error);
    void serverUnavailable();

private:
    void handleRequest();

    PlayModality _playModality;
    QString _userName;
    QString _userIdentifier;
    QString _roomIdentifier;
    QString _gameIdentifier;
    QTcpSocket *_socket;
    QQmlPropertyMap *_data;
};

#endif // CORE_H_
