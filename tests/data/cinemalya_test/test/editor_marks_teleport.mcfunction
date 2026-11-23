# @template cinemalya_test:room
# @environment cinemalya_test:editor_keyframes
# @dummy ~ ~ ~
# @timeout 400
await score #cinemalya.loaded load.status matches 1

forceload add -8 -8 8 8
await delay 5
function #cinemalya:v1/editor/start
tp @s 1.5 200 0.5 0 0
dummy @s use
await score #keyframes cinemalya.data matches 1

# A teleport needs a keyframe to leave from
dummy @s swap
await delay 3
assert not data storage cinemalya:editor keyframes[0].tp

tp @s 30.5 200 0.5 90 0
dummy @s use
await score #keyframes cinemalya.data matches 2

# Swapping hands marks the last keyframe and leaves the item in the main hand
dummy @s swap
await data storage cinemalya:editor keyframes[1].tp
await items entity @s weapon.mainhand *[custom_data~{cinemalya:{editor:true}}]
assert not items entity @s weapon.offhand *

# The export writes it on the last keyframe, and swapping again flies to the keyframe once more
tp @s 3.5 200 1.5 0 0
dummy @s drop
await data storage cinemalya:editor export.abs
assert data storage cinemalya:editor export{tp:",tp:true"}

dummy @s swap
await not data storage cinemalya:editor keyframes[1].tp

function #cinemalya:v1/editor/stop
forceload remove -8 -8 8 8
