function th=gps_bearing(lat1,long1,lat2,long2)
dlong = circ_distd(long2,long1);
th = mod(90-atan2d(sind(dlong)*cosd(lat2),cosd(lat1)*sind(lat2)-sind(lat1)*cosd(lat2)*cosd(dlong)),360);