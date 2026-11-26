
#> cinemalya:v1.2.1/playback/remove_double
#
# @executed	at @s
#
# @within	cinemalya:v1.2.1/playback/kill
#

scoreboard players operation #player_id cinemalya.id = @s cinemalya.id
kill @e[type=mannequin,tag=cinemalya.double,predicate=cinemalya:has_same_id]

