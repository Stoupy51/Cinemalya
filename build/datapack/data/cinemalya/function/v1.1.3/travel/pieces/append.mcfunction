
#> cinemalya:v1.1.3/travel/pieces/append
#
# @within	cinemalya:v1.1.3/travel/pieces/next
#
# @description		Chain this piece's frames after the previous ones, noting where the camera jumps.
#

execute if data storage cinemalya:work acc.points[0] run function cinemalya:v1.1.3/travel/pieces/mark_cut
data modify storage cinemalya:work acc.points append from storage cinemalya:work frames.points[]
data modify storage cinemalya:work acc.rotations append from storage cinemalya:work frames.rotations[]
data modify storage cinemalya:work acc.events append from storage cinemalya:work frames.events[]

