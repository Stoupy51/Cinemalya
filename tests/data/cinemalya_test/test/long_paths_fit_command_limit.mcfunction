# @template cinemalya_test:room
# @environment cinemalya_test:editor_keyframes
# @timeout 100
await score #cinemalya.loaded load.status matches 1

# Past 65536 commands Minecraft drops the rest of a launch silently, and no camera appears
forceload add -64 -64 200 64
execute positioned 0 200 0 run function #cinemalya:v1/launch_path {with:{gamemode:"none",duration:36000,waypoints:[{pos:[0.0,200.0,0.0]},{pos:[150.0,220.0,40.0]}]}}
execute store result score #frames cinemalya.data run data get storage cinemalya:work frames.points
assert score #frames cinemalya.data matches 600
assert entity @e[type=item_display,tag=cinemalya.cinematic]
kill @e[type=item_display,tag=cinemalya.cinematic]

# 18 waypoints, whose durations ask for more frames than the cap
execute positioned -46.75 63.42 -16.54 run function #cinemalya:v1/launch_path {with:{gamemode:"none",ease:"ease_in_out",smoothing:1,duration:1200,waypoints:[{at:"~0.00 ~0.00 ~0.00",rot:[-89.56,0.47]},{at:"~9.48 ~3.93 ~0.07",rot:[-89.48,0.63]},{at:"~27.19 ~8.24 ~3.94",rot:[-107.53,4.67]},{at:"~43.44 ~8.25 ~-3.16",rot:[-58.98,5.00]},{at:"~52.09 ~8.25 ~4.42",rot:[-108.02,-12.97]},{at:"~56.95 ~10.12 ~3.54",rot:[-138.02,2.86]},{at:"~63.09 ~10.12 ~-2.98",rot:[-60.38,1.79]},{at:"~72.81 ~10.12 ~3.68",rot:[-104.23,1.46]},{at:"~85.43 ~10.12 ~0.56",rot:[-70.69,1.70]},{at:"~95.84 ~10.12 ~2.56",rot:[-116.18,2.03]},{at:"~105.38 ~10.12 ~-0.31",rot:[-57.25,1.95]},{at:"~117.83 ~10.12 ~4.11",rot:[-85.69,1.95]},{at:"~127.34 ~10.12 ~3.65",rot:[129.92,11.76]},{at:"~127.62 ~10.12 ~-4.76",rot:[80.55,4.67]},{at:"~117.91 ~10.12 ~-5.19",rot:[83.27,0.80]},{at:"~109.14 ~10.12 ~-6.36",rot:[147.72,1.29]},{at:"~103.06 ~10.12 ~-11.61",rot:[79.81,1.54]},{at:"~86.91 ~19.11 ~-17.35",rot:[55.90,14.15],duration:100}]}}
execute store result score #frames cinemalya.data run data get storage cinemalya:work frames.points
assert score #frames cinemalya.data matches 600
assert entity @e[type=item_display,tag=cinemalya.cinematic]
kill @e[type=item_display,tag=cinemalya.cinematic]
forceload remove -64 -64 200 64
