
#> cinemalya:v1.1.1/editor/label
#
# @executed	anchored eyes & positioned ^ ^ ^
#
# @within	cinemalya:v1.1.1/editor/place [ anchored eyes & positioned ^ ^ ^ ]
#
# @output storage	cinemalya:editor new : {pos:[x,y,z]}, the keyframe being placed
#

tag @s add cinemalya.keyframe
scoreboard players operation @s cinemalya.data = #keyframes cinemalya.data
data modify entity @s billboard set value "center"
data modify entity @s see_through set value 1b
function cinemalya:v1.1.1/editor/label_text with storage cinemalya:editor label
data modify storage cinemalya:editor new set value {}
data modify storage cinemalya:editor new.pos set from entity @s Pos

