
#> cinemalya:v1.1.3/travel/pieces/build
#
# @within	cinemalya:v1.1.3/travel/pieces/next
#
# @description		The usual pipeline on this piece alone, with the part of the duration its segments are worth.
#

scoreboard players operation #duration cinemalya.data = #total_duration cinemalya.data
scoreboard players operation #duration cinemalya.data *= #segments cinemalya.data
scoreboard players operation #duration cinemalya.data /= #total_segments cinemalya.data
execute if score #duration cinemalya.data matches ..0 run scoreboard players set #duration cinemalya.data 1
execute if score #duration cinemalya.data matches 36001.. run scoreboard players set #duration cinemalya.data 36000

function cinemalya:v1.1.3/travel/control/main
function cinemalya:v1.1.3/travel/sample/main
function cinemalya:v1.1.3/travel/frames/main

