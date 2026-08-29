
#> cinemalya:v1.0.1/travel/waypoints/anchor_setup
#
# @within	cinemalya:v1.0.1/travel/waypoints/open_anchor
#

tag @s add cinemalya.anchor
tag @s add global.ignore
tp @s ~ ~ ~ facing entity @e[type=marker,tag=cinemalya.anchor_ahead,limit=1] feet

