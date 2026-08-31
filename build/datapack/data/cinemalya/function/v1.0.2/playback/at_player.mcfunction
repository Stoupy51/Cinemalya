
#> cinemalya:v1.0.2/playback/at_player
#
# @executed	at @a[tag=cinemalya.temp,limit=1]
#
# @within	cinemalya:v1.0.2/playback/tick [ at @a[tag=cinemalya.temp,limit=1] ]
#
# @description		Keep the player glued to the camera. Re-issuing /spectate every tick is what
# 				survives a death, a dimension change, or the player pressing a movement key.
#

tp @a[distance=0,tag=cinemalya.temp,limit=1] @s
execute at @s run spectate @s @a[distance=0,tag=cinemalya.temp,limit=1]
function cinemalya:v1.0.2/playback/advance

