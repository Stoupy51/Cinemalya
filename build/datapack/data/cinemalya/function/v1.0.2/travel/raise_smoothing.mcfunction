
#> cinemalya:v1.0.2/travel/raise_smoothing
#
# @within	cinemalya:v1.0.2/travel/defaults
#
# @input score		#duration cinemalya.data
# @output score		#smoothing cinemalya.data : the smallest value keeping the travel under 1200 frames
# 
# @description		Round the division up, so the frame count lands just under the cap instead of just over it.
#

scoreboard players operation #smoothing cinemalya.data = #duration cinemalya.data
scoreboard players add #smoothing cinemalya.data 1199
scoreboard players operation #smoothing cinemalya.data /= #1200 cinemalya.data

