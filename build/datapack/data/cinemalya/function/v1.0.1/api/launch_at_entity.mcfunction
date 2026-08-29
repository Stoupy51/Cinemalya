
#> cinemalya:v1.0.1/api/launch_at_entity
#
# @within	#cinemalya:v1/launch_at_entity
#
# @args		with (unknown)
#
# @description		Version guard: only the newest cinemalya loaded in the world runs the call.
#

$execute if score #cinemalya.major load.status matches 1 if score #cinemalya.minor load.status matches 0 if score #cinemalya.patch load.status matches 1 run function cinemalya:v1.0.1/travel/from_entity {with:$(with)}

