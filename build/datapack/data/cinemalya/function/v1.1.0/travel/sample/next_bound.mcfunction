
#> cinemalya:v1.1.0/travel/sample/next_bound
#
# @within	cinemalya:v1.1.0/travel/sample/measure
#			cinemalya:v1.1.0/travel/sample/bound
#
# @output score		#next cinemalya.data : the sample standing for waypoint #k, splitting the samples evenly between segments
#

scoreboard players add #k cinemalya.data 1
scoreboard players operation #next cinemalya.data = #k cinemalya.data
scoreboard players operation #next cinemalya.data *= #last cinemalya.data
scoreboard players operation #n cinemalya.data = #segments cinemalya.data
scoreboard players operation #n cinemalya.data /= #2 cinemalya.data
scoreboard players operation #next cinemalya.data += #n cinemalya.data
scoreboard players operation #next cinemalya.data /= #segments cinemalya.data

