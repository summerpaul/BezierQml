#ifndef ROADMAPREADER_H
#define ROADMAPREADER_H

#include <QString>
#include <QFile>
#include <QVector>
#include <QDir>
#include "mapInfo.h"
#include <QQmlListProperty>
class RoadmapReader
{
public:
    RoadmapReader();
    void nodeFileRead(const QString & fileName);
    void laneFileRead(const QString & fileName);
    bool mapReady(){return m_point_ready && m_lane_ready;}
    QQmlListProperty<Point> getPoints(){return m_points;}
    QQmlListProperty<Lane> getLanes(){return m_lanes;}


private:
    QQmlListProperty<Point> m_points;
    QQmlListProperty<Lane> m_lanes;
    bool m_point_ready;
    bool m_lane_ready;

};

#endif // ROADMAPREADER_H
