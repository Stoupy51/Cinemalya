
#> cinemalya:v1.0.0/travel/frames/ease_out
#
# @within	cinemalya:v1.0.0/travel/frames/ease
#

# One minus the square of the remainder: fastest at launch, settling onto the target
scoreboard players operation #q cinemalya.data = #10000 cinemalya.data
scoreboard players operation #q cinemalya.data -= #p cinemalya.data
scoreboard players operation #q cinemalya.data *= #q cinemalya.data
scoreboard players operation #q cinemalya.data /= #10000 cinemalya.data
scoreboard players operation #p cinemalya.data = #10000 cinemalya.data
scoreboard players operation #p cinemalya.data -= #q cinemalya.data

