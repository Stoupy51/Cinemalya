
#> cinemalya:v1.0.0/api/launch
#
# @within	#cinemalya:v1/launch
#
# @args		with (unknown)
#
# @description		Version guard: only the newest cinemalya loaded in the world runs the call.
#

$execute if score #cinemalya.major load.status matches 1 if score #cinemalya.minor load.status matches 0 if score #cinemalya.patch load.status matches 0 run function cinemalya:v1.0.0/travel/from_coords {with:$(with)}

