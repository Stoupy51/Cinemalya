# @template cinemalya_test:room
# @environment cinemalya_test:editor_keyframes
# @dummy ~ ~ ~
# @timeout 200
await score #cinemalya.loaded load.status matches 1

function #cinemalya:v1/editor/start
assert items entity @s weapon.mainhand *[custom_data~{cinemalya:{editor:true}}]

tp @s ~1.5 ~ ~1.5 90 10
dummy @s use
await score #keyframes cinemalya.data matches 1
tp @s ~3.5 ~ ~3.5 -90 -10
dummy @s use
await score #keyframes cinemalya.data matches 2
assert data storage cinemalya:editor keyframes[{rot:[-90.0f,-10.0f]}]
assert data storage cinemalya:editor trail[0]
execute positioned ~3.5 ~1.62 ~3.5 run assert entity @e[type=text_display,tag=cinemalya.keyframe,distance=..0.01,scores={cinemalya.data=2}]

function #cinemalya:v1/editor/stop
assert not items entity @s container.* *[custom_data~{cinemalya:{editor:true}}]
assert not data storage cinemalya:editor keyframes[0]
execute positioned ~1.5 ~1.62 ~1.5 run assert not entity @e[type=text_display,tag=cinemalya.keyframe,distance=..0.5]
