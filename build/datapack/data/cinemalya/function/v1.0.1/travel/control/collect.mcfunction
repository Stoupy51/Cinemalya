
#> cinemalya:v1.0.1/travel/control/collect
#
# @within	cinemalya:v1.0.1/travel/control/collect_one with storage cinemalya:work sel
#
# @args		i (unknown)
#

$data modify storage cinemalya:work control.points append from storage cinemalya:work args.waypoints[$(i)].pos
$data modify storage cinemalya:work rot_control.points append from storage cinemalya:work args.waypoints[$(i)].rot

