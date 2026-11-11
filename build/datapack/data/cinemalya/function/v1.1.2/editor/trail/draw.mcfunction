
#> cinemalya:v1.1.2/editor/trail/draw
#
# @within	cinemalya:v1.1.2/editor/tick
#
# @description		Each dot lives for 40 ticks while it travels its segment, so four of them
# 				are always on the way and the line reads as flowing from the first keyframe to the last.
#

scoreboard players set #trail_clock cinemalya.data 0
execute unless data storage cinemalya:editor trail[0] run return 0
data modify storage cinemalya:editor drawing set from storage cinemalya:editor trail
function cinemalya:v1.1.2/editor/trail/loop

