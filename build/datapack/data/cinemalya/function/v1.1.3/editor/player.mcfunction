
#> cinemalya:v1.1.3/editor/player
#
# @executed	as @a[tag=cinemalya.editor]
#
# @within	cinemalya:v1.1.3/editor/tick [ as @a[tag=cinemalya.editor] ]
#

execute if score @s cinemalya.click matches 1.. at @s run function cinemalya:v1.1.3/editor/on_use
execute if score @s cinemalya.drop matches 1.. at @s run function cinemalya:v1.1.3/editor/on_drop
execute if items entity @s weapon.offhand *[custom_data~{cinemalya:{editor:true}}] at @s run function cinemalya:v1.1.3/editor/on_swap

