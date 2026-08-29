
#> cinemalya:v1.0.1/travel/waypoints/normalize_loop
#
# @within	cinemalya:v1.0.1/travel/waypoints/normalize
#			cinemalya:v1.0.1/travel/waypoints/normalize_one
#

execute if score #w cinemalya.data < #count cinemalya.data run function cinemalya:v1.0.1/travel/waypoints/normalize_one

