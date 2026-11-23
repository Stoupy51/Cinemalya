
#> cinemalya:v1.1.3/travel/attach
#
# @executed	as the cinematic entity
#
# @within	cinemalya:v1.1.3/travel/spawn
#
# @description		Bind the launching player to this cinematic and hand them over to the camera.
#

execute unless entity @s[tag=cinemalya.keep_gamemode] run function cinemalya:v1.1.3/travel/remember_gamemode
scoreboard players operation @p[tag=cinemalya.temp] cinemalya.id = @s cinemalya.id
execute if score #double cinemalya.data matches 1 run tag @s add cinemalya.double
execute if score #double cinemalya.data matches 1 as @p[tag=cinemalya.temp] at @s run function cinemalya:v1.1.3/travel/double/spawn
execute if score #protect cinemalya.data matches 1 run function cinemalya:v1.1.3/travel/protect
execute if entity @s[tag=cinemalya.ride] run return run ride @p[tag=cinemalya.temp] mount @s

# As the player: a gamemode set by anyone else is announced in their chat
execute as @p[tag=cinemalya.temp] run gamemode spectator @s
spectate @s @p[tag=cinemalya.temp]

