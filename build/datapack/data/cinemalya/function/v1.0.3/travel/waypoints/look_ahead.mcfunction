
#> cinemalya:v1.0.3/travel/waypoints/look_ahead
#
# @executed	in the caller's own execution context
#
# @within	cinemalya:v1.0.3/travel/waypoints/resolve_at
#			cinemalya:v1.0.3/travel/waypoints/target_here
#			cinemalya:v1.0.3/intro/start
#
# @output storage	cinemalya:work ahead : the point one block down the caller's line of sight
# 
# @description		`execute summon` grants the execution position but not the execution rotation, so the
# 				rotation is recovered by facing a point one block ahead. That point is read off the
# 				marker standing on it instead of being selected back later: a chunk the caller only
# 				just teleported into still holds entities no selector can see.
#

execute positioned ^ ^ ^1 summon marker run function cinemalya:v1.0.3/travel/waypoints/read_ahead

