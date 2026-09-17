
#> cinemalya:v1.0.4/travel/frames/segment_loop
#
# @within	cinemalya:v1.0.4/travel/frames/main
#			cinemalya:v1.0.4/travel/frames/segment
#

execute if score #budget cinemalya.data matches 1.. if score #seg cinemalya.data < #segments cinemalya.data run function cinemalya:v1.0.4/travel/frames/segment

