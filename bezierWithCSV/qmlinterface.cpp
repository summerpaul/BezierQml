#include "qmlinterface.h"
#include <QDebug>
QmlInterface::QmlInterface(QObject *parent) : QObject(parent)
{

}
void QmlInterface::setNodePath(QString nodePath)
{
    m_nodePath = nodePath;
    qDebug() << "node file path is " << m_nodePath;
    m_reader.nodeFileRead(nodePath);

}

void QmlInterface::setLanePath(QString lanePath)
{
    m_lanePath = lanePath;
    qDebug() << "lane file path is " << m_lanePath;
    m_reader.laneFileRead(lanePath);
}
