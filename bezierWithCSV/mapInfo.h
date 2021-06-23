#ifndef MAPINFO_H
#define MAPINFO_H
#include <string>
struct Point
{
    int point_id_;
    double x_;
    double y_;
    double yaw_;
    std::string description_;

    Point()
    {
        point_id_ = 0;
        x_=0;
        y_=0;
        yaw_=0;
        description_ = "none";
    }
};

struct Lane
{
    int lane_id_;
    int FN_id_;
    int BN_id_;
    std::string lane_type_;
    double p1_;
    double p2_;
    double hdg_;
    double length_;
    double speed_;
    int motion_type_;
    Lane()
    {
        lane_id_ = 0;
        FN_id_ = 0;
        BN_id_ = 0;
        lane_type_ = "unknown";
        p1_=0;
        p2_=0;
        hdg_=0;
        length_=0;
        speed_=0;
        motion_type_=0;
    }
};
#endif // MAPINFO_H
