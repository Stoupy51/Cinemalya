# @template cinemalya_test:room
# @environment cinemalya_test:editor_keyframes
# @timeout 200
await score #cinemalya.loaded load.status matches 1

# Segments of 4, 8 and 4 blocks over 40 frames: one speed means 0.4 blocks a frame, waypoints on frames 10 and 30
forceload add -8 -8 24 8
execute positioned 0 200 0 run function #cinemalya:v1/launch_path {with:{gamemode:"none",ease:"linear",duration:40,smoothing:1,waypoints:[{pos:[0.0,200.0,0.0]},{pos:[4.0,200.0,0.0]},{pos:[12.0,200.0,0.0]},{pos:[16.0,200.0,0.0]}]}}
execute store result score #frames cinemalya.data run data get storage cinemalya:work frames.points
assert score #frames cinemalya.data matches 40

execute store result score #x cinemalya.data run data get storage cinemalya:work frames.points[4][0] 100
assert score #x cinemalya.data matches 195..205
execute store result score #x cinemalya.data run data get storage cinemalya:work frames.points[9][0] 100
assert score #x cinemalya.data matches 395..405
execute store result score #x cinemalya.data run data get storage cinemalya:work frames.points[14][0] 100
assert score #x cinemalya.data matches 595..605
execute store result score #x cinemalya.data run data get storage cinemalya:work frames.points[19][0] 100
assert score #x cinemalya.data matches 795..805
execute store result score #x cinemalya.data run data get storage cinemalya:work frames.points[29][0] 100
assert score #x cinemalya.data matches 1195..1205
execute store result score #x cinemalya.data run data get storage cinemalya:work frames.points[39][0] 100
assert score #x cinemalya.data matches 1600

await not entity @e[type=item_display,tag=cinemalya.cinematic]
forceload remove -8 -8 24 8
