#include "roadmapreader.h"
#include <QDebug>
RoadmapReader::RoadmapReader():m_point_ready(false), m_lane_ready(false)
{

}
void RoadmapReader::nodeFileRead(const QString & fileName)
{
    if(fileName =="")
    {
        return;
    }
    QDir dir = QDir::current();
    QFile point_file(dir.filePath((fileName)));

    if(!point_file.open((QIODevice::ReadOnly)))
    {
        qDebug()<<"OPEN FILE FAILED";
    }



    QTextStream stream(&point_file);

    QStringList tempOption;
    while (!stream.atEnd())
    {
        tempOption.push_back(stream.readLine()); //保存到List当中
    }
    for (int i = 1; i < tempOption.count(); i++)
    {
        Point temp_point;
        QStringList tempbar = tempOption.at(i).split(",");
        temp_point.point_id_ = tempbar[0].toInt();
        temp_point.x_ = tempbar[1].toDouble();
        temp_point.y_ = tempbar[2].toDouble();
        temp_point.description_ = tempbar[3].toStdString();
//        m_points.push_back(temp_point);
        m_points.append()
    }
    qDebug() << "points numbre is " << m_points.size();
    m_point_ready = true;
    point_file.close();
}

void RoadmapReader::laneFileRead(const QString & fileName)
{
    if(fileName =="")
    {
        return;
    }
    QDir dir = QDir::current();
    QFile lane_file(dir.filePath((fileName)));

    if(!lane_file.open((QIODevice::ReadOnly)))
    {
        qDebug()<<"OPEN FILE FAILED";
    }
    QTextStream stream(&lane_file);

    QStringList tempOption;
    while (!stream.atEnd())
    {
        tempOption.push_back(stream.readLine()); //保存到List当中
    }
    for (int i = 1; i < tempOption.count(); i++)
    {
        Lane temp_lane;
        QStringList tempbar = tempOption.at(i).split(",");
        temp_lane.lane_id_ = tempbar[0].toInt();
        temp_lane.BN_id_ = tempbar[1].toInt();
        temp_lane.FN_id_ = tempbar[2].toInt();
        temp_lane.lane_type_ = tempbar[3].toStdString();
        temp_lane.p1_ = tempbar[4].toDouble();
        temp_lane.p2_ = tempbar[5].toDouble();
        temp_lane.hdg_ = tempbar[6].toDouble();
        temp_lane.length_ = tempbar[7].toDouble();
        temp_lane.speed_ = tempbar[8].toDouble();
        temp_lane.motion_type_ = tempbar[9].toInt();
        m_lanes.push_back(temp_lane);
    }
    qDebug() << "Lanes number is " << m_lanes.size();
    m_lane_ready = true;
    lane_file.close();

}
