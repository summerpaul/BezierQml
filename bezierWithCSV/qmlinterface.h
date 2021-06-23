#ifndef QMLINTERFACE_H
#define QMLINTERFACE_H

#include <QObject>
#include <QString>
#include <QVector>
#include <QQmlListProperty>
#include "roadmapreader.h"
class QmlInterface : public QObject
{
    Q_PROPERTY(QString nodePath WRITE setNodePath)
    Q_PROPERTY(QString lanePath WRITE setLanePath)
    Q_PROPERTY(QQmlListProperty<Point> points READ getPoints )
    Q_PROPERTY(QQmlListProperty<Lane> lanes READ getLanes )

    Q_OBJECT
public:
    explicit QmlInterface(QObject *parent = nullptr);
    Q_INVOKABLE void setNodePath(QString nodePath);
    Q_INVOKABLE void setLanePath(QString lanePath);
    QQmlListProperty<Point>  getPoints(){return m_reader.getPoints();}
    QQmlListProperty<Lane> getLanes(){return m_reader.getLanes();}
signals:



private:
    QString m_nodePath;
    QString m_lanePath;
    RoadmapReader m_reader;

};

#endif // QMLINTERFACE_H
