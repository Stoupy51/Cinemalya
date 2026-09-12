
#> cinemalya:v1.0.3/api/launch
#
# @within	#cinemalya:v1/launch
#
# @args		with (unknown)
#
# @description		Version guard: only the newest cinemalya loaded in the world runs the call.
# 				The loaded check matters just as much. The version scores are set the moment the pack
# 				is read, while the constants every computation divides by are written by confirm_load,
# 				which waits for a player to be online. A call landing in that window would compute its
# 				sampling step from zeroed constants and hang the server inside the spline sampler.
#

$execute if score #cinemalya.loaded load.status matches 1 if score #cinemalya.major load.status matches 1 if score #cinemalya.minor load.status matches 0 if score #cinemalya.patch load.status matches 3 run function cinemalya:v1.0.3/travel/from_coords {with:$(with)}

