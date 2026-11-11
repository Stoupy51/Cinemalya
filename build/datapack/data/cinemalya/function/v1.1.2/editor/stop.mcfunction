
#> cinemalya:v1.1.2/editor/stop
#
# @executed	as the player
#
# @within	cinemalya:v1.1.2/api/editor/stop
#
# @description		Take the editor item back. The last editor to stop also clears the shared path.
#

execute unless entity @s[tag=cinemalya.editor] run return fail
tag @s remove cinemalya.editor
scoreboard players remove #editors cinemalya.data 1
clear @s *[custom_data~{cinemalya:{editor:true}}]
execute if score #editors cinemalya.data matches ..0 run function cinemalya:v1.1.2/editor/reset

