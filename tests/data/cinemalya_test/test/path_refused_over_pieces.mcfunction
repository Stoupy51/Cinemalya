# @template cinemalya_test:room
# @dummy ~ ~ ~
# @timeout 200
await score #cinemalya.loaded load.status matches 1

# Nine pieces is one more than a path takes: nothing is launched
function #cinemalya:v1/launch_path {with:{waypoints:[{args:[1.5,201.6,0.5,0,0]},{args:[2.5,201.6,0.5,0,0]},{args:[10,201.6,0.5,0,0],tp:true},{args:[11,201.6,0.5,0,0]},{args:[20,201.6,0.5,0,0],tp:true},{args:[21,201.6,0.5,0,0]},{args:[30,201.6,0.5,0,0],tp:true},{args:[31,201.6,0.5,0,0]},{args:[40,201.6,0.5,0,0],tp:true},{args:[41,201.6,0.5,0,0]},{args:[50,201.6,0.5,0,0],tp:true},{args:[51,201.6,0.5,0,0]},{args:[60,201.6,0.5,0,0],tp:true},{args:[61,201.6,0.5,0,0]},{args:[70,201.6,0.5,0,0],tp:true},{args:[71,201.6,0.5,0,0]},{args:[80,201.6,0.5,0,0],tp:true},{args:[81,201.6,0.5,0,0]}]}}
await delay 5
assert not entity @e[type=item_display,tag=cinemalya.cinematic,distance=..200]
