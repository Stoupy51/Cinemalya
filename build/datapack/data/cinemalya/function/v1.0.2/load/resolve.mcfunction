
#> cinemalya:v1.0.2/load/resolve
#
# @within	#cinemalya:resolve
#

# If correct version, load the datapack
execute if score #cinemalya.major load.status matches 1 if score #cinemalya.minor load.status matches 0 if score #cinemalya.patch load.status matches 2 run function cinemalya:v1.0.2/load/main

