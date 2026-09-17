
#> cinemalya:v1.0.4/load/main
#
# @within	cinemalya:v1.0.4/load/resolve
#

# Avoiding multiple executions of the same load function
execute unless score #cinemalya.loaded load.status matches 1 run function cinemalya:v1.0.4/load/secondary

