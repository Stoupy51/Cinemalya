
#> cinemalya:v1.1.1/editor/trail/add
#
# @executed	at @s
#
# @within	cinemalya:v1.1.1/editor/place
#
# @description		Store the segment ending on the newest keyframe, so drawing never has to pair keyframes up.
#

data modify storage cinemalya:editor segment set value {}
data modify storage cinemalya:editor segment.x set from storage cinemalya:editor keyframes[-2].pos[0]
data modify storage cinemalya:editor segment.y set from storage cinemalya:editor keyframes[-2].pos[1]
data modify storage cinemalya:editor segment.z set from storage cinemalya:editor keyframes[-2].pos[2]
data modify storage cinemalya:editor segment.tx set from storage cinemalya:editor keyframes[-1].pos[0]
data modify storage cinemalya:editor segment.ty set from storage cinemalya:editor keyframes[-1].pos[1]
data modify storage cinemalya:editor segment.tz set from storage cinemalya:editor keyframes[-1].pos[2]
data modify storage cinemalya:editor trail append from storage cinemalya:editor segment

