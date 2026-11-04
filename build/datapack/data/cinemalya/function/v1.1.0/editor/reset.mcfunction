
#> cinemalya:v1.1.0/editor/reset
#
# @within	cinemalya:v1.1.0/editor/stop
#			string in cinemalya:v1.1.0/editor/export/main
#
# @description		Forget every keyframe and take their numbers down.
#

kill @e[type=text_display,tag=cinemalya.keyframe]
data modify storage cinemalya:editor keyframes set value []
data modify storage cinemalya:editor trail set value []
scoreboard players set #keyframes cinemalya.data 0

