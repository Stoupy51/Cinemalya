
#> cinemalya:v1.1.3/travel/pieces/take
#
# @within	cinemalya:v1.1.3/travel/pieces/next
#			cinemalya:v1.1.3/travel/pieces/take
#

data modify storage cinemalya:work args.waypoints append from storage cinemalya:work rest[0]
data remove storage cinemalya:work rest[0]
execute if data storage cinemalya:work rest[0] unless data storage cinemalya:work rest[0].tp run function cinemalya:v1.1.3/travel/pieces/take

