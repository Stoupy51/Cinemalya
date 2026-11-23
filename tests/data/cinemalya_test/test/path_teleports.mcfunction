# @template cinemalya_test:room
# @environment cinemalya_test:editor_keyframes
# @timeout 400
await score #cinemalya.loaded load.status matches 1

# Two pieces of one 4 block segment each: 20 frames apiece, the second one starting on its own frame at the teleport waypoint
forceload add -8 -8 120 8
scoreboard players set #fired cinemalya.data 0
execute positioned 0 200 0 run function #cinemalya:v1/launch_path {with:{gamemode:"none",ease:"linear",duration:40,smoothing:1,waypoints:[{pos:[0.0,200.0,0.0],function:"cinemalya_test:count_waypoint"},{pos:[4.0,200.0,0.0],function:"cinemalya_test:count_waypoint"},{pos:[100.0,200.0,0.0],tp:true,delay:5,function:"cinemalya_test:count_waypoint"},{pos:[104.0,200.0,0.0],function:"cinemalya_test:count_waypoint"}]}}

execute store result score #frames cinemalya.data run data get storage cinemalya:work frames.points
assert score #frames cinemalya.data matches 41

# The camera reaches the end of the first piece, then lands exactly on the teleport waypoint, without a frame in between
execute store result score #x cinemalya.data run data get storage cinemalya:work frames.points[19][0] 100
assert score #x cinemalya.data matches 400
execute store result score #x cinemalya.data run data get storage cinemalya:work frames.points[20][0] 100
assert score #x cinemalya.data matches 10000
execute store result score #x cinemalya.data run data get storage cinemalya:work frames.points[40][0] 100
assert score #x cinemalya.data matches 10400

# One cut: the pop that lands on the teleport waypoint, and the ticks it holds there
execute store result score #cut cinemalya.data run data get storage cinemalya:work frames.cuts[0].at
assert score #cut cinemalya.data matches 21
execute store result score #hold cinemalya.data run data get storage cinemalya:work frames.cuts[0].delay
assert score #hold cinemalya.data matches 5
assert not data storage cinemalya:work frames.cuts[1]

# Every waypoint reaches its frame, counted from the first of the whole path
execute store result score #events cinemalya.data run data get storage cinemalya:work frames.events
assert score #events cinemalya.data matches 4
execute store result score #at cinemalya.data run data get storage cinemalya:work frames.events[2].at
assert score #at cinemalya.data matches 21
execute store result score #wp cinemalya.data run data get storage cinemalya:work frames.events[3].wp
assert score #wp cinemalya.data matches 3

# Playing it fires each waypoint's function exactly once, and ends
await not entity @e[type=item_display,tag=cinemalya.cinematic]
assert score #fired cinemalya.data matches 4
forceload remove -8 -8 120 8
