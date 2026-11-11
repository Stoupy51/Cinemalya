
#> cinemalya:v1.1.2/editor/export/loop
#
# @executed	at @s
#
# @within	cinemalya:v1.1.2/editor/export/main
#			cinemalya:v1.1.2/editor/export/loop
#

execute store result score #x cinemalya.data run data get storage cinemalya:editor iter[0].pos[0] 100
execute store result score #y cinemalya.data run data get storage cinemalya:editor iter[0].pos[1] 100
execute store result score #z cinemalya.data run data get storage cinemalya:editor iter[0].pos[2] 100
execute store result score #yaw cinemalya.data run data get storage cinemalya:editor iter[0].rot[0] 100
execute store result score #pitch cinemalya.data run data get storage cinemalya:editor iter[0].rot[1] 100
scoreboard players operation #dx cinemalya.data = #x cinemalya.data
scoreboard players operation #dx cinemalya.data -= #x0 cinemalya.data
scoreboard players operation #dy cinemalya.data = #y cinemalya.data
scoreboard players operation #dy cinemalya.data -= #y0 cinemalya.data
scoreboard players operation #dz cinemalya.data = #z cinemalya.data
scoreboard players operation #dz cinemalya.data -= #z0 cinemalya.data

data modify storage cinemalya:editor export.x_s set value ""
execute if score #x cinemalya.data matches ..-1 run data modify storage cinemalya:editor export.x_s set value "-"
execute if score #x cinemalya.data matches ..-1 run scoreboard players operation #x cinemalya.data *= #-1 cinemalya.data
scoreboard players operation #x_i cinemalya.data = #x cinemalya.data
execute store result storage cinemalya:editor export.x_i int 1 run scoreboard players operation #x_i cinemalya.data /= #100 cinemalya.data
execute store result storage cinemalya:editor export.x_f int 1 run scoreboard players operation #x cinemalya.data %= #100 cinemalya.data
data modify storage cinemalya:editor export.x_p set value ""
execute if score #x cinemalya.data matches ..9 run data modify storage cinemalya:editor export.x_p set value "0"

data modify storage cinemalya:editor export.y_s set value ""
execute if score #y cinemalya.data matches ..-1 run data modify storage cinemalya:editor export.y_s set value "-"
execute if score #y cinemalya.data matches ..-1 run scoreboard players operation #y cinemalya.data *= #-1 cinemalya.data
scoreboard players operation #y_i cinemalya.data = #y cinemalya.data
execute store result storage cinemalya:editor export.y_i int 1 run scoreboard players operation #y_i cinemalya.data /= #100 cinemalya.data
execute store result storage cinemalya:editor export.y_f int 1 run scoreboard players operation #y cinemalya.data %= #100 cinemalya.data
data modify storage cinemalya:editor export.y_p set value ""
execute if score #y cinemalya.data matches ..9 run data modify storage cinemalya:editor export.y_p set value "0"

data modify storage cinemalya:editor export.z_s set value ""
execute if score #z cinemalya.data matches ..-1 run data modify storage cinemalya:editor export.z_s set value "-"
execute if score #z cinemalya.data matches ..-1 run scoreboard players operation #z cinemalya.data *= #-1 cinemalya.data
scoreboard players operation #z_i cinemalya.data = #z cinemalya.data
execute store result storage cinemalya:editor export.z_i int 1 run scoreboard players operation #z_i cinemalya.data /= #100 cinemalya.data
execute store result storage cinemalya:editor export.z_f int 1 run scoreboard players operation #z cinemalya.data %= #100 cinemalya.data
data modify storage cinemalya:editor export.z_p set value ""
execute if score #z cinemalya.data matches ..9 run data modify storage cinemalya:editor export.z_p set value "0"

data modify storage cinemalya:editor export.dx_s set value ""
execute if score #dx cinemalya.data matches ..-1 run data modify storage cinemalya:editor export.dx_s set value "-"
execute if score #dx cinemalya.data matches ..-1 run scoreboard players operation #dx cinemalya.data *= #-1 cinemalya.data
scoreboard players operation #dx_i cinemalya.data = #dx cinemalya.data
execute store result storage cinemalya:editor export.dx_i int 1 run scoreboard players operation #dx_i cinemalya.data /= #100 cinemalya.data
execute store result storage cinemalya:editor export.dx_f int 1 run scoreboard players operation #dx cinemalya.data %= #100 cinemalya.data
data modify storage cinemalya:editor export.dx_p set value ""
execute if score #dx cinemalya.data matches ..9 run data modify storage cinemalya:editor export.dx_p set value "0"

data modify storage cinemalya:editor export.dy_s set value ""
execute if score #dy cinemalya.data matches ..-1 run data modify storage cinemalya:editor export.dy_s set value "-"
execute if score #dy cinemalya.data matches ..-1 run scoreboard players operation #dy cinemalya.data *= #-1 cinemalya.data
scoreboard players operation #dy_i cinemalya.data = #dy cinemalya.data
execute store result storage cinemalya:editor export.dy_i int 1 run scoreboard players operation #dy_i cinemalya.data /= #100 cinemalya.data
execute store result storage cinemalya:editor export.dy_f int 1 run scoreboard players operation #dy cinemalya.data %= #100 cinemalya.data
data modify storage cinemalya:editor export.dy_p set value ""
execute if score #dy cinemalya.data matches ..9 run data modify storage cinemalya:editor export.dy_p set value "0"

data modify storage cinemalya:editor export.dz_s set value ""
execute if score #dz cinemalya.data matches ..-1 run data modify storage cinemalya:editor export.dz_s set value "-"
execute if score #dz cinemalya.data matches ..-1 run scoreboard players operation #dz cinemalya.data *= #-1 cinemalya.data
scoreboard players operation #dz_i cinemalya.data = #dz cinemalya.data
execute store result storage cinemalya:editor export.dz_i int 1 run scoreboard players operation #dz_i cinemalya.data /= #100 cinemalya.data
execute store result storage cinemalya:editor export.dz_f int 1 run scoreboard players operation #dz cinemalya.data %= #100 cinemalya.data
data modify storage cinemalya:editor export.dz_p set value ""
execute if score #dz cinemalya.data matches ..9 run data modify storage cinemalya:editor export.dz_p set value "0"

data modify storage cinemalya:editor export.yaw_s set value ""
execute if score #yaw cinemalya.data matches ..-1 run data modify storage cinemalya:editor export.yaw_s set value "-"
execute if score #yaw cinemalya.data matches ..-1 run scoreboard players operation #yaw cinemalya.data *= #-1 cinemalya.data
scoreboard players operation #yaw_i cinemalya.data = #yaw cinemalya.data
execute store result storage cinemalya:editor export.yaw_i int 1 run scoreboard players operation #yaw_i cinemalya.data /= #100 cinemalya.data
execute store result storage cinemalya:editor export.yaw_f int 1 run scoreboard players operation #yaw cinemalya.data %= #100 cinemalya.data
data modify storage cinemalya:editor export.yaw_p set value ""
execute if score #yaw cinemalya.data matches ..9 run data modify storage cinemalya:editor export.yaw_p set value "0"

data modify storage cinemalya:editor export.pitch_s set value ""
execute if score #pitch cinemalya.data matches ..-1 run data modify storage cinemalya:editor export.pitch_s set value "-"
execute if score #pitch cinemalya.data matches ..-1 run scoreboard players operation #pitch cinemalya.data *= #-1 cinemalya.data
scoreboard players operation #pitch_i cinemalya.data = #pitch cinemalya.data
execute store result storage cinemalya:editor export.pitch_i int 1 run scoreboard players operation #pitch_i cinemalya.data /= #100 cinemalya.data
execute store result storage cinemalya:editor export.pitch_f int 1 run scoreboard players operation #pitch cinemalya.data %= #100 cinemalya.data
data modify storage cinemalya:editor export.pitch_p set value ""
execute if score #pitch cinemalya.data matches ..9 run data modify storage cinemalya:editor export.pitch_p set value "0"

function cinemalya:v1.1.2/editor/export/append with storage cinemalya:editor export
data modify storage cinemalya:editor export.sep set value ","
data remove storage cinemalya:editor iter[0]
execute if data storage cinemalya:editor iter[0] run function cinemalya:v1.1.2/editor/export/loop

