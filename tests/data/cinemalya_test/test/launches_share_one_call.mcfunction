# @template cinemalya_test:room
# @environment cinemalya_test:editor_keyframes
# @timeout 200
await score #cinemalya.loaded load.status matches 1

# Other tests launch at tick 0 and use up the same commands, so wait for them
await delay 30

# Launches made by one command share its 65536 commands, and none may be dropped
forceload add -8 -8 40 8
summon marker 0 200 0 {Tags:["cinemalya_test.burst"]}
summon marker 0 200 0 {Tags:["cinemalya_test.burst"]}
summon marker 0 200 0 {Tags:["cinemalya_test.burst"]}
execute as @e[type=marker,tag=cinemalya_test.burst] at @s run function #cinemalya:v1/launch_path {with:{gamemode:"none",duration:200,tags:["cinemalya_test.burst_camera"],waypoints:[{pos:[0.0,200.0,0.0]},{pos:[30.0,200.0,0.0]}]}}
execute store result score #cameras cinemalya.data if entity @e[type=item_display,tag=cinemalya_test.burst_camera]
kill @e[type=marker,tag=cinemalya_test.burst]
kill @e[type=item_display,tag=cinemalya_test.burst_camera]
forceload remove -8 -8 40 8
assert score #cameras cinemalya.data matches 3
