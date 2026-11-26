
#> cinemalya:v1.2.1/playback/move_double
#
# @executed	at @a[tag=cinemalya.temp,limit=1]
#
# @within	cinemalya:v1.2.1/playback/at_player
#
# @description		Stand the mannequin under the camera, looking where it looks.
#

tp @e[type=mannequin,tag=cinemalya.double,predicate=cinemalya:has_same_id,limit=1] @s
execute as @e[type=mannequin,tag=cinemalya.double,predicate=cinemalya:has_same_id,limit=1] at @s run function cinemalya:v1.2.1/playback/lower_double

