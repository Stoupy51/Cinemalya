
#> cinemalya:v1.0.3/travel/waypoints/face_ahead
#
# @executed	as a marker standing on the caller's position
#
# @within	cinemalya:v1.0.3/travel/waypoints/read_here with storage cinemalya:work ahead
#			cinemalya:v1.0.3/travel/waypoints/resolve_at_anchor with storage cinemalya:work ahead
#
# @args		x (unknown)
#			y (unknown)
#			z (unknown)
#
# @input macro		x, y, z : double - the point look_ahead read one block down the line of sight
#

$tp @s ~ ~ ~ facing $(x) $(y) $(z)

