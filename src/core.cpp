#include "core.h"

#include <QDebug>
#include <QTcpSocket>
#include <QQmlPropertyMap>

Core::Core(QObject *parent)
    : _socket(new QTcpSocket(this)),
      _playModality { PlayModality::Multiplayer },
      _data { new QQmlPropertyMap(this) },
      _playerIndex { 0 }
{
    if (_socket->bind()) {
        _socket->connectToHost("127.0.0.1", 8080);
        _socket->setSocketOption(QAbstractSocket::KeepAliveOption, 1);
        connect(_socket, &QTcpSocket::readyRead, this, &Core::handleRequest);
        connect(_socket, &QAbstractSocket::errorOccurred, this, [=]() {
            qDebug() << "error " << _socket->error();
            emit errorHappened(_socket->errorString());
        });
    } else {
        qDebug() << "error, couldnt reserve socket";
    }
}

Core::~Core()
{
    logout();
    _socket->disconnectFromHost();
    _socket->close();
}

void Core::resetData()
{
    for (const auto &key : _data->keys()) {
        _data->clear(key);
    }
}

void Core::login(const QString &username)
{
    _socket->write(u"player register %1"_qs.arg(username).toUtf8());
}

void Core::logout()
{
    _socket->write(u"player logout %1"_qs.arg(_userIdentifier).toUtf8());
}

void Core::rooms()
{
    _socket->write("room list all");
}

void Core::createRoom(const QString &roomName, const QString &difficulty)
{
    _socket->write(u"room create %1 %2 %3"_qs.arg(roomName).arg(_userIdentifier).arg(difficulty).toUtf8());
}

void Core::joinRoom(const QString &roomUid)
{
    _socket->write(u"room join %1 %2"_qs.arg(roomUid).arg(_userIdentifier).toUtf8());
}

void Core::sendRoomMessage(const QString &message)
{
    _socket->write(
            u"room send_msg %1 %2 %3"_qs.arg(_roomIdentifier).arg(_userIdentifier).arg(message).toUtf8());
}

void Core::kickPlayerRoom(int indexPlayer)
{
    _socket->write(
            u"room kick %1 %2 %3"_qs.arg(_roomIdentifier).arg(_userIdentifier).arg(indexPlayer).toUtf8());
}

void Core::exitRoom()
{
    _socket->write(u"room exit %1 %2"_qs.arg(_roomIdentifier).arg(_userIdentifier).toUtf8());
}

void Core::startGame(PlayModality modality)
{
    _playModality = modality;
    if (modality == PlayModality::Solo && _roomIdentifier.isEmpty()) { // creates room first for solo play
        _socket->write(u"room create %1 %2 %3"_qs.arg(_userName + "Solo")
                               .arg(_userIdentifier)
                               .arg("medio")
                               .toUtf8());
    } else {
        _socket->write(u"room start_game %1 %2"_qs.arg(_roomIdentifier).arg(_userIdentifier).toUtf8());
    }
}

void Core::gamePlayerIndex()
{
    _socket->write(u"game player_index %1 %2"_qs.arg(_gameIdentifier).arg(_userIdentifier).toUtf8());
}

void Core::exitGame()
{
    _socket->write(u"game exit %1 %2"_qs.arg(_gameIdentifier).arg(_userIdentifier).toUtf8());
}

void Core::gameGuessLetter(const QChar guessed)
{
    _socket->write(
            u"game guess_letter %1 %2 %3"_qs.arg(_gameIdentifier).arg(_userIdentifier).arg(guessed).toUtf8());
}

void Core::gameGuessWord(const QString &guessed)
{
    _socket->write(
            u"game guess_word %1 %2 %3"_qs.arg(_gameIdentifier).arg(_userIdentifier).arg(guessed).toUtf8());
}

void Core::handleRequest()
{
    auto dataReceived { QJsonDocument::fromJson(_socket->readAll()).object() };
    qDebug() << "metadata: " << dataReceived << "\n";
    if (dataReceived.contains("error")) {
        emit errorHappened(dataReceived["error"].toString());
        return;

    } else if (dataReceived["event"] == "RoomListChanged") {
        emit roomListChanged(dataReceived["data"].toArray());

    } else if (dataReceived["event"] == "RoomMessageReceived") {
        emit roomMessageReceived(dataReceived["data"].toObject());
        return;

    } else if (dataReceived["event"] == "PlayerIndexFound") {
        _playerIndex = dataReceived["data"].toObject()["player_index"].toInt();
        emit playerIndexChanged(_playerIndex);
        return;

    } else if (dataReceived["event"] == "GameExited") {
        _gameIdentifier = "";
        _playModality = PlayModality::Multiplayer;
        _playerIndex = 0;

    } else if (dataReceived["event"] == "RoomExited") {
        _roomIdentifier = "";

    } else {
        const auto metadata { dataReceived["data"].toObject() };

        const auto datamap = metadata.toVariantMap(); // populating the data used on the current screen
        for (auto keyValueIterator = datamap.constBegin(); keyValueIterator != datamap.constEnd();
             keyValueIterator++) {
            _data->insert(keyValueIterator.key(), keyValueIterator.value());
        }

        if (dataReceived["event"] == "PlayerCreated") {
            _userName = metadata["name"].toString();
            _userIdentifier = metadata["uid"].toString();
            emit playerCreated(_userName);

        } else if (dataReceived["event"] == "RoomCreated") {
            _roomIdentifier = metadata["uid"].toString();
            if (_playModality != PlayModality::Solo) {
                emit roomCreated(metadata);
            } else { // room is ready, then start the solo play
                startGame(_playModality);
            }
        } else if (dataReceived["event"] == "RoomDeleted") {
            _roomIdentifier = "";
            emit roomDeleted();

        } else if (dataReceived["event"] == "RoomChanged") {
            emit dataChanged(_data);
            emit roomChanged(metadata);

        } else if (dataReceived["event"] == "GameStarted") {
            _roomIdentifier = ""; // room doesnt exist anymore as the game started

            _gameIdentifier = metadata["uid"].toString();
            emit dataChanged(_data);
            emit gameStarted(metadata);
            gamePlayerIndex();

        } else if (dataReceived["event"] == "GameChanged") {
            emit dataChanged(_data);
            emit gameChanged(metadata);

        } else if (dataReceived["event"] == "PlayerEliminated") {
            _gameIdentifier = "";
            _playModality = PlayModality::Multiplayer;
            emit playerEliminated();

        } else if (dataReceived["event"] == "GameFinished") {
            _gameIdentifier = "";
            _playModality = PlayModality::Multiplayer;
            emit gameFinished(metadata);
        }

        return;
    }

    resetData();
}
