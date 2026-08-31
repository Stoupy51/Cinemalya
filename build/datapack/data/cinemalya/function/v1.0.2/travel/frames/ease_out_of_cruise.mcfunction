
#> cinemalya:v1.0.2/travel/frames/ease_out_of_cruise
#
# @within	cinemalya:v1.0.2/travel/frames/ease
#
# @description		The mirror of ease_in_to_cruise: leaves its waypoint at cruising speed and settles
# 				to rest, so the handover into it is seamless too.
#

scoreboard players operation #u cinemalya.data = #10000 cinemalya.data
scoreboard players operation #u cinemalya.data -= #p cinemalya.data
scoreboard players operation #q cinemalya.data = #u cinemalya.data
scoreboard players operation #q cinemalya.data *= #u cinemalya.data
scoreboard players operation #q cinemalya.data /= #10000 cinemalya.data
scoreboard players operation #r cinemalya.data = #q cinemalya.data
scoreboard players operation #r cinemalya.data *= #u cinemalya.data
scoreboard players operation #r cinemalya.data /= #10000 cinemalya.data
scoreboard players operation #q cinemalya.data *= #2 cinemalya.data
scoreboard players operation #q cinemalya.data -= #r cinemalya.data
scoreboard players operation #p cinemalya.data = #10000 cinemalya.data
scoreboard players operation #p cinemalya.data -= #q cinemalya.data

