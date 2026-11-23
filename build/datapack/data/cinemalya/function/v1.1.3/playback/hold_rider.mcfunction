
#> cinemalya:v1.1.3/playback/hold_rider
#
# @executed	at @a[tag=cinemalya.temp,limit=1]
#
# @within	cinemalya:v1.1.3/playback/at_player
#
# @description		A rider the camera carries needs no teleport. Sneaking dismounts it, so it is put back on every tick it is not aboard.
#

scoreboard players set #aboard cinemalya.data 0
execute on passengers run scoreboard players set #aboard cinemalya.data 1
execute if score #aboard cinemalya.data matches 0 run ride @a[tag=cinemalya.temp,limit=1] mount @s
function cinemalya:v1.1.3/playback/advance

