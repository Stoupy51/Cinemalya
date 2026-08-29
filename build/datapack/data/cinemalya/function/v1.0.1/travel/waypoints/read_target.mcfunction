
#> cinemalya:v1.0.1/travel/waypoints/read_target
#
# @within	cinemalya:v1.0.1/travel/waypoints/target_from_entity with storage cinemalya:work args
#
# @args		target (unknown)
#
# @input macro		target : string - the selector to copy the position and rotation from
#

$data modify storage cinemalya:work wp.pos set from entity $(target) Pos
$data modify storage cinemalya:work wp.rot set from entity $(target) Rotation

