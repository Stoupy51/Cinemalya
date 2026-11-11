
#> cinemalya:v1.1.2/travel/sample/root
#
# @within	cinemalya:v1.1.2/travel/sample/measure_step
#
# @input score		#sq cinemalya.data : the squared length of a sample interval
# @output score		#length cinemalya.data : grown by that interval's length, its integer square root
# 
# @description		Newton's method, seeded with the previous interval's root since neighbours are close.
# 				Its first step lands above the root from any seed, then the rest fall onto it from above.
#

scoreboard players operation #quot cinemalya.data = #sq cinemalya.data
scoreboard players operation #quot cinemalya.data /= #root cinemalya.data
scoreboard players operation #root cinemalya.data += #quot cinemalya.data
scoreboard players operation #root cinemalya.data /= #2 cinemalya.data
function cinemalya:v1.1.2/travel/sample/root_descend
scoreboard players operation #length cinemalya.data += #root cinemalya.data

