
#> cinemalya:v1.1.0/editor/preview
#
# @executed	at @s
#
# @within	cinemalya:v1.1.0/editor/on_use
#			string in cinemalya:v1.1.0/editor/export/main
#
# @description		Fly the player along the keyframes, timed like the exported command.
#

execute if score #keyframes cinemalya.data matches ..1 run return run title @s actionbar {text:"Place at least two keyframes to preview",color:"red"}
data modify storage cinemalya:editor preview set value {with:{duration:200}}
data modify storage cinemalya:editor preview.with.waypoints set from storage cinemalya:editor keyframes
function cinemalya:v1.1.0/travel/from_waypoints with storage cinemalya:editor preview

