
#> cinemalya:v1.0.0/travel/frames/ease_in_to_cruise
#
# @within	cinemalya:v1.0.0/travel/frames/ease
#
# @description		2t^2 - t^3: starts at rest like ease_in, but arrives at exactly the speed a linear
# 				segment travels at, so the waypoint it hands over on shows no change of pace.
#

scoreboard players operation #q cinemalya.data = #p cinemalya.data
scoreboard players operation #q cinemalya.data *= #p cinemalya.data
scoreboard players operation #q cinemalya.data /= #10000 cinemalya.data
scoreboard players operation #r cinemalya.data = #q cinemalya.data
scoreboard players operation #r cinemalya.data *= #p cinemalya.data
scoreboard players operation #r cinemalya.data /= #10000 cinemalya.data
scoreboard players operation #p cinemalya.data = #q cinemalya.data
scoreboard players operation #p cinemalya.data *= #2 cinemalya.data
scoreboard players operation #p cinemalya.data -= #r cinemalya.data

