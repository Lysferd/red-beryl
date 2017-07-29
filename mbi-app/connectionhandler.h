#ifndef CONNECTIONHANDLER_H
#define CONNECTIONHANDLER_H

#include <QObject>

class ConnectionHandler : public QObject
{
    Q_OBJECT
public:
    explicit ConnectionHandler(QObject *parent = nullptr);

signals:

public slots:
};

#endif // CONNECTIONHANDLER_H
