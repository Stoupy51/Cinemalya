# @template cinemalya_test:room
# @environment cinemalya_test:editor_export
# @dummy ~ ~ ~
# @timeout 700
await score #cinemalya.loaded load.status matches 1

# Ward places tests millions of blocks out, past what launch_path reads from `args` (it scales them by 1000 into an int)
forceload add -8 -8 8 8
await delay 5
fill -4 199 0 4 199 4 minecraft:barrier
function #cinemalya:v1/editor/start
tp @s 1.5 200 0.5 0 0
dummy @s use
await score #keyframes cinemalya.data matches 1
tp @s 3.5 201 1.5 45 10
dummy @s use
await score #keyframes cinemalya.data matches 2
tp @s -3.5 200 3.5 90 20
dummy @s use
await score #keyframes cinemalya.data matches 3

# Dropping the item opens the export and hands the item back (a dummy drops nothing out of its test area)
tp @s ~2.5 ~ ~2.5
dummy @s drop
await data storage cinemalya:editor export.rel
await items entity @s weapon.mainhand *[custom_data~{cinemalya:{editor:true}}]

# Both commands land the camera on the last keyframe, which sets the player down 1.6 blocks under it
tp @s 1.5 200 1.5
function cinemalya_test:run_absolute with storage cinemalya:editor export
await entity @s[gamemode=spectator]
await not entity @s[gamemode=spectator]
execute positioned -3.5 200.02 3.5 run assert entity @s[distance=..0.05,y_rotation=89..91,x_rotation=19..21]

tp @s 1.5 200 1.5
function cinemalya_test:run_relative with storage cinemalya:editor export
await entity @s[gamemode=spectator]
await not entity @s[gamemode=spectator]
execute positioned -3.5 200.02 3.5 run assert entity @s[distance=..0.05,y_rotation=89..91,x_rotation=19..21]

function #cinemalya:v1/editor/stop
fill -4 199 0 4 199 4 minecraft:air
forceload remove -8 -8 8 8
