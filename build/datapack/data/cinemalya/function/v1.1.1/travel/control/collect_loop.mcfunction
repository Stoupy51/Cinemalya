
#> cinemalya:v1.1.1/travel/control/collect_loop
#
# @within	cinemalya:v1.1.1/travel/control/through
#			cinemalya:v1.1.1/travel/control/collect_one
#

execute if score #w cinemalya.data < #count cinemalya.data run function cinemalya:v1.1.1/travel/control/collect_one

