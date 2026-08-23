
#> cinemalya:v1.0.0/travel/waypoints/open_anchor
#
# @executed	in the caller's own execution context
#
# @within	cinemalya:v1.0.0/travel/waypoints/target_here
#			cinemalya:v1.0.0/travel/waypoints/normalize
#
# @output			a marker tagged cinemalya.anchor, standing on the execution position and facing its rotation
# 
# @description		`execute summon` grants the execution position but not the execution rotation, so a
# 				second marker one block down the line of sight gives the anchor something to face.
# 				Both are needed: `~` coordinates want the position, `^` ones want the rotation too.
#

execute positioned ^ ^ ^1 summon marker run function cinemalya:v1.0.0/travel/waypoints/anchor_ahead
execute summon marker run function cinemalya:v1.0.0/travel/waypoints/anchor_setup

