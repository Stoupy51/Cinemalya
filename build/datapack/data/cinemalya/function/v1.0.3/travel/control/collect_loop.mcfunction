
#> cinemalya:v1.0.3/travel/control/collect_loop
#
# @within	cinemalya:v1.0.3/travel/control/through
#			cinemalya:v1.0.3/travel/control/collect_one
#

execute if score #w cinemalya.data < #count cinemalya.data run function cinemalya:v1.0.3/travel/control/collect_one

