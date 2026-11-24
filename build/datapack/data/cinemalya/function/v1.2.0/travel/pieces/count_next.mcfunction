
#> cinemalya:v1.2.0/travel/pieces/count_next
#
# @within	cinemalya:v1.2.0/travel/pieces/count
#			cinemalya:v1.2.0/travel/pieces/count_next
#

execute unless data storage cinemalya:work scan[0] run return 0
execute if data storage cinemalya:work scan[0].tp run scoreboard players add #pieces cinemalya.data 1
data remove storage cinemalya:work scan[0]
function cinemalya:v1.2.0/travel/pieces/count_next

