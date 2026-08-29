
#> cinemalya:v1.0.1/travel/waypoints/target_from_entity
#
# @within	cinemalya:v1.0.1/travel/from_entity
#
# @description		Close the waypoint list on another entity's position and rotation, at eye height.
#

data modify storage cinemalya:work wp set value {pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}
function cinemalya:v1.0.1/travel/waypoints/read_target with storage cinemalya:work args
function cinemalya:v1.0.1/travel/waypoints/raise_eyes
function cinemalya:v1.0.1/travel/waypoints/override_rotation
data modify storage cinemalya:work args.waypoints append from storage cinemalya:work wp

