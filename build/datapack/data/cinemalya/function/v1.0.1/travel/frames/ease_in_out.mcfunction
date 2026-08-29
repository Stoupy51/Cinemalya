
#> cinemalya:v1.0.1/travel/frames/ease_in_out
#
# @within	cinemalya:v1.0.1/travel/frames/ease
#

# Smoothstep, staged through two divisions so the intermediate product stays inside an int
scoreboard players operation #q cinemalya.data = #p cinemalya.data
scoreboard players operation #q cinemalya.data *= #p cinemalya.data
scoreboard players operation #q cinemalya.data /= #10000 cinemalya.data
scoreboard players operation #p cinemalya.data *= #-2 cinemalya.data
scoreboard players operation #p cinemalya.data += #30000 cinemalya.data
scoreboard players operation #p cinemalya.data *= #q cinemalya.data
scoreboard players operation #p cinemalya.data /= #10000 cinemalya.data

