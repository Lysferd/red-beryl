#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtCore/QLoggingCategory>
#include <QtSql>

#include "connectionhandler.h"
#include "devicefinder.h"
#include "devicehandler.h"
#include "patientmodel.h"

int main(int argc, char *argv[]) {
    QLoggingCategory::setFilterRules(QStringLiteral("qt.bluetooth* = true"));
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qmlRegisterType<PatientModel>("Backend", 1, 0, "PatientModel");

    ConnectionHandler connectionHandler;
    DeviceHandler deviceHandler;
    DeviceFinder deviceFinder(&deviceHandler);
    qmlRegisterUncreatableType<DeviceHandler>("Shared", 1, 0, "AddressType",
                                              "Enum is not a type");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("connectionHandler",
                                             &connectionHandler);
    engine.rootContext()->setContextProperty("deviceFinder", &deviceFinder);
    engine.rootContext()->setContextProperty("deviceHandler", &deviceHandler);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
