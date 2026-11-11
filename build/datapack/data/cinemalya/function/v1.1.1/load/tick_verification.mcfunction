
#> cinemalya:v1.1.1/load/tick_verification
#
# @within	#minecraft:tick
#

execute if score #cinemalya.major load.status matches 1 if score #cinemalya.minor load.status matches 1 if score #cinemalya.patch load.status matches 1 run function cinemalya:v1.1.1/tick

