
#> cinemalya:v1.1.0/travel/sample/root_descend
#
# @within	cinemalya:v1.1.0/travel/sample/root
#			cinemalya:v1.1.0/travel/sample/root_descend
#

scoreboard players operation #quot cinemalya.data = #sq cinemalya.data
scoreboard players operation #quot cinemalya.data /= #root cinemalya.data
scoreboard players operation #quot cinemalya.data += #root cinemalya.data
scoreboard players operation #quot cinemalya.data /= #2 cinemalya.data
execute unless score #quot cinemalya.data < #root cinemalya.data run return 0
scoreboard players operation #root cinemalya.data = #quot cinemalya.data
function cinemalya:v1.1.0/travel/sample/root_descend

