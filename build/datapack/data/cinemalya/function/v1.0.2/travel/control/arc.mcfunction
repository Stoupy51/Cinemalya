
#> cinemalya:v1.0.2/travel/control/arc
#
# @within	cinemalya:v1.0.2/travel/control/main
#
# @description		A four point bezier from the first waypoint to the last, bending through a raised
# 				midpoint. The end is repeated so the curve settles onto it instead of overshooting.
#

function cinemalya:v1.0.2/travel/control/mid_point
data modify storage cinemalya:work control.points append from storage cinemalya:work args.waypoints[0].pos
data modify storage cinemalya:work control.points append from storage cinemalya:work mid
data modify storage cinemalya:work control.points append from storage cinemalya:work args.waypoints[-1].pos
data modify storage cinemalya:work control.points append from storage cinemalya:work args.waypoints[-1].pos

# The rotation gets no arc: it just eases from the start heading to the target one
data modify storage cinemalya:work rot_control.points append from storage cinemalya:work args.waypoints[0].rot
data modify storage cinemalya:work rot_control.points append from storage cinemalya:work args.waypoints[0].rot
data modify storage cinemalya:work rot_control.points append from storage cinemalya:work args.waypoints[-1].rot
data modify storage cinemalya:work rot_control.points append from storage cinemalya:work args.waypoints[-1].rot

