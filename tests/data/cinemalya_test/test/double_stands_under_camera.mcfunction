# @template cinemalya_test:room
# @dummy ~ ~ ~
# @timeout 400
await score #cinemalya.loaded load.status matches 1

forceload add -8 -8 24 8
tp @s 1.5 200 0.5 0 0
item replace entity @s weapon.mainhand with minecraft:diamond_sword
function #cinemalya:v1/launch_path {with:{body:"mannequin",pose:"swimming",arc_height:0.0,duration:40,waypoints:[{args:[1.5,201.6,0.5,0,0]},{args:[9.5,201.6,0.5,0,0]}]}}

# The mannequin has the player's hands and lies down one eye height under the camera
await entity @e[type=mannequin,tag=cinemalya.double,tag=cinemalya.pose_swimming]
await delay 3
await data entity @n[type=mannequin,tag=cinemalya.double] equipment.mainhand{id:"minecraft:diamond_sword"}
assert data entity @n[type=mannequin,tag=cinemalya.double] profile
execute as @e[type=item_display,tag=cinemalya.cinematic] store result score #camera_y cinemalya.data run data get entity @s Pos[1] 100
execute as @e[type=mannequin,tag=cinemalya.double] store result score #mannequin_y cinemalya.data run data get entity @s Pos[1] 100
scoreboard players operation #camera_y cinemalya.data -= #mannequin_y cinemalya.data
assert score #camera_y cinemalya.data matches 40

# It goes with the camera
await not entity @e[type=item_display,tag=cinemalya.cinematic]
assert not entity @e[type=mannequin,tag=cinemalya.double]

# A bare hand stays bare, the head the skin was read off is not left in it
item replace entity @s weapon.mainhand with minecraft:air
function #cinemalya:v1/launch_path {with:{body:"mannequin",duration:40,waypoints:[{args:[1.5,201.6,0.5,0,0]},{args:[9.5,201.6,0.5,0,0]}]}}
await entity @e[type=mannequin,tag=cinemalya.double]
assert not data entity @n[type=mannequin,tag=cinemalya.double] equipment.mainhand
await not entity @e[type=item_display,tag=cinemalya.cinematic]
forceload remove -8 -8 24 8
