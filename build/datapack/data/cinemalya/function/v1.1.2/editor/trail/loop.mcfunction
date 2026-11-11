
#> cinemalya:v1.1.2/editor/trail/loop
#
# @within	cinemalya:v1.1.2/editor/trail/draw
#			cinemalya:v1.1.2/editor/trail/loop
#

function cinemalya:v1.1.2/editor/trail/dot with storage cinemalya:editor drawing[0]
data remove storage cinemalya:editor drawing[0]
execute if data storage cinemalya:editor drawing[0] run function cinemalya:v1.1.2/editor/trail/loop

