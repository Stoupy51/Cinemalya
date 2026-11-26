
#> cinemalya:v1.2.1/playback/at_player
#
# @executed	at @a[tag=cinemalya.temp,limit=1]
#
# @within	cinemalya:v1.2.1/playback/tick [ at @a[tag=cinemalya.temp,limit=1] ]
#
# @description		Keep the player glued to the camera. Re-issuing /spectate every tick is what
# 				survives a death, a dimension change, or the player pressing a movement key.
#

execute if entity @s[tag=cinemalya.ride] run return run function cinemalya:v1.2.1/playback/hold_rider
tp @a[distance=0,tag=cinemalya.temp,limit=1] @s
execute at @s run spectate @s @a[distance=0,tag=cinemalya.temp,limit=1]
execute if entity @s[tag=cinemalya.double] run function cinemalya:v1.2.1/playback/move_double
function cinemalya:v1.2.1/playback/advance

