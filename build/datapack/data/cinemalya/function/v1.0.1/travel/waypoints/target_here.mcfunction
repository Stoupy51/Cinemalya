
#> cinemalya:v1.0.1/travel/waypoints/target_here
#
# @executed	as the player,in the caller's execution context
#
# @within	cinemalya:v1.0.1/travel/from_here
#
# @description		Close the waypoint list on wherever the command was pointing, at eye height.
# 				This is what lets a command block aim a cinematic with `~` and `^` coordinates.
#

function cinemalya:v1.0.1/travel/waypoints/open_anchor
function cinemalya:v1.0.1/travel/waypoints/read_anchor
function cinemalya:v1.0.1/travel/waypoints/close_anchor
function cinemalya:v1.0.1/travel/waypoints/raise_eyes
function cinemalya:v1.0.1/travel/waypoints/override_rotation
data modify storage cinemalya:work args.waypoints append from storage cinemalya:work wp

