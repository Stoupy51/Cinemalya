
#> cinemalya:v1.1.1/travel/frames/land
#
# @within	cinemalya:v1.1.1/travel/frames/frame
#
# @description		Append the point lying at distance #s, interpolated between the interval's two samples.
# 				Snapping to the nearest sample instead would make every step one or two samples long.
#

scoreboard players operation #fr cinemalya.data = #s cinemalya.data
scoreboard players operation #fr cinemalya.data -= #from_length cinemalya.data
scoreboard players operation #fr cinemalya.data *= #1000 cinemalya.data
scoreboard players operation #fr cinemalya.data /= #interval cinemalya.data

data modify storage cinemalya:work frames.points append value [0.0d,0.0d,0.0d]
scoreboard players operation #v cinemalya.data = #step_x cinemalya.data
scoreboard players operation #v cinemalya.data *= #fr cinemalya.data
scoreboard players operation #v cinemalya.data /= #1000 cinemalya.data
execute store result storage cinemalya:work frames.points[-1][0] double 0.001 run scoreboard players operation #v cinemalya.data += #from_x cinemalya.data
scoreboard players operation #v cinemalya.data = #step_y cinemalya.data
scoreboard players operation #v cinemalya.data *= #fr cinemalya.data
scoreboard players operation #v cinemalya.data /= #1000 cinemalya.data
execute store result storage cinemalya:work frames.points[-1][1] double 0.001 run scoreboard players operation #v cinemalya.data += #from_y cinemalya.data
scoreboard players operation #v cinemalya.data = #step_z cinemalya.data
scoreboard players operation #v cinemalya.data *= #fr cinemalya.data
scoreboard players operation #v cinemalya.data /= #1000 cinemalya.data
execute store result storage cinemalya:work frames.points[-1][2] double 0.001 run scoreboard players operation #v cinemalya.data += #from_z cinemalya.data

data modify storage cinemalya:work frames.rotations append value [0.0f,0.0f]
scoreboard players operation #v cinemalya.data = #step_yaw cinemalya.data
scoreboard players operation #v cinemalya.data *= #fr cinemalya.data
scoreboard players operation #v cinemalya.data /= #1000 cinemalya.data
execute store result storage cinemalya:work frames.rotations[-1][0] float 0.001 run scoreboard players operation #v cinemalya.data += #from_yaw cinemalya.data
scoreboard players operation #v cinemalya.data = #step_pitch cinemalya.data
scoreboard players operation #v cinemalya.data *= #fr cinemalya.data
scoreboard players operation #v cinemalya.data /= #1000 cinemalya.data
execute store result storage cinemalya:work frames.rotations[-1][1] float 0.001 run scoreboard players operation #v cinemalya.data += #from_pitch cinemalya.data

