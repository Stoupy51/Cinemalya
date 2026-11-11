
#> cinemalya:v1.1.2/editor/tick
#
# @within	cinemalya:v1.1.2/tick
#
# @description		Runs only while someone is editing, gated by #editors in the tick function.
#

execute as @a[tag=cinemalya.editor] run function cinemalya:v1.1.2/editor/player
scoreboard players add #trail_clock cinemalya.data 1
execute if score #trail_clock cinemalya.data matches 10.. run function cinemalya:v1.1.2/editor/trail/draw

