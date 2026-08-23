
#> cinemalya:v1.0.0/travel/tags/one
#
# @within	cinemalya:v1.0.0/travel/tags/loop
#

execute store result storage cinemalya:work sel.i int 1 run scoreboard players get #t cinemalya.data
function cinemalya:v1.0.0/travel/tags/read with storage cinemalya:work sel
function cinemalya:v1.0.0/travel/tags/apply with storage cinemalya:work one_tag
scoreboard players add #t cinemalya.data 1
function cinemalya:v1.0.0/travel/tags/loop

