
#> cinemalya:v1.0.0/travel/frames/ease
#
# @within	cinemalya:v1.0.0/travel/frames/frame
#
# @input score		#p cinemalya.data : linear progress, 0 to 10000
# @output score		#p cinemalya.data : eased progress, 0 to 10000
# 
# @description		Bend the progress so the camera accelerates, decelerates, or does both.
#

execute if score #ease cinemalya.data matches 1 run function cinemalya:v1.0.0/travel/frames/ease_in
execute if score #ease cinemalya.data matches 2 run function cinemalya:v1.0.0/travel/frames/ease_out
execute if score #ease cinemalya.data matches 3 run function cinemalya:v1.0.0/travel/frames/ease_in_out
execute if score #ease cinemalya.data matches 4 run function cinemalya:v1.0.0/travel/frames/ease_in_to_cruise
execute if score #ease cinemalya.data matches 5 run function cinemalya:v1.0.0/travel/frames/ease_out_of_cruise

