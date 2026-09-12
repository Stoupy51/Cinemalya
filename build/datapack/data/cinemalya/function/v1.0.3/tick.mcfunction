
#> cinemalya:v1.0.3/tick
#
# @within	cinemalya:v1.0.3/load/tick_verification
#

# Cinematic playback (the score gate keeps the selector out of the tick when nothing is playing)
execute if score #entities cinemalya.data matches 1.. as @e[type=item_display,tag=cinemalya.cinematic] at @s run function cinemalya:v1.0.3/playback/tick

