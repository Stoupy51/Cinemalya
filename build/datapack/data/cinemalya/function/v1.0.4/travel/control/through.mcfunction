
#> cinemalya:v1.0.4/travel/control/through
#
# @within	cinemalya:v1.0.4/travel/control/main
#
# @description		Control points that make the curve pass through every waypoint: the sampler reads
# 				four at a time, so the first and last are repeated to give the ends a tangent.
#

data modify storage cinemalya:work control.points append from storage cinemalya:work args.waypoints[0].pos
data modify storage cinemalya:work rot_control.points append from storage cinemalya:work args.waypoints[0].rot
scoreboard players set #w cinemalya.data 0
function cinemalya:v1.0.4/travel/control/collect_loop
data modify storage cinemalya:work control.points append from storage cinemalya:work args.waypoints[-1].pos
data modify storage cinemalya:work rot_control.points append from storage cinemalya:work args.waypoints[-1].rot

