
#> cinemalya:v1.0.3/playback/tick
#
# @executed	at @s
#
# @within	cinemalya:v1.0.3/tick [ at @s ]
#
# @description		Resolve the player riding this cinematic, then advance it by one tick.
#

# Full precision rotation, which matters most on the frames the camera is actually turning
execute if entity @s[tag=cinemalya.precise] run function cinemalya:v1.0.3/playback/precise_rotation

# A free flying camera has nobody to carry along
execute if entity @s[tag=cinemalya.detached] run return run function cinemalya:v1.0.3/playback/advance

# Tag the rider, storing success so the same selector also tells us whether they are still online
scoreboard players operation #player_id cinemalya.id = @s cinemalya.id
execute store success score #found cinemalya.data run tag @a[predicate=cinemalya:has_same_id,limit=1] add cinemalya.temp
execute if score #found cinemalya.data matches 0 run return run function cinemalya:v1.0.3/playback/kill

execute at @a[tag=cinemalya.temp,limit=1] run function cinemalya:v1.0.3/playback/at_player
tag @a[tag=cinemalya.temp,limit=1] remove cinemalya.temp

