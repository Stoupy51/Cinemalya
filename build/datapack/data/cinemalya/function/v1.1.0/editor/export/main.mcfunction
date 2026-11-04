
#> cinemalya:v1.1.0/editor/export/main
#
# @executed	at @s
#
# @within	cinemalya:v1.1.0/editor/on_drop
#
# @output storage	cinemalya:editor export.abs, export.rel : the two commands, shown in a dialog
#

execute if score #keyframes cinemalya.data matches ..1 run return run title @s actionbar {text:"Place at least two keyframes to export",color:"red"}
data modify storage cinemalya:editor export set value {abs:"",rel:"",sep:""}
data modify storage cinemalya:editor iter set from storage cinemalya:editor keyframes
execute store result score #x0 cinemalya.data run data get storage cinemalya:editor keyframes[0].pos[0] 100
execute store result score #y0 cinemalya.data run data get storage cinemalya:editor keyframes[0].pos[1] 100
execute store result score #z0 cinemalya.data run data get storage cinemalya:editor keyframes[0].pos[2] 100
function cinemalya:v1.1.0/editor/export/loop

## The relative command is positioned on the first keyframe
scoreboard players operation #x cinemalya.data = #x0 cinemalya.data
scoreboard players operation #y cinemalya.data = #y0 cinemalya.data
scoreboard players operation #z cinemalya.data = #z0 cinemalya.data

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

function cinemalya:v1.1.0/editor/export/wrap with storage cinemalya:editor export

data modify storage cinemalya:editor dialog set value {"type": "minecraft:multi_action", "title": {"text": "Cinemalya Export", "color": "gold", "bold": true}, "body": [{"type": "minecraft:plain_message", "width": 400, "contents": [{"text": "Click a box, then ", "color": "white"}, {"text": "Ctrl+A", "color": "yellow"}, {"text": " and ", "color": "white"}, {"text": "Ctrl+C", "color": "yellow"}, {"text": ", and paste it in a command block or a function: chat cuts commands at ", "color": "white"}, {"text": "256 characters", "color": "red"}, {"text": ".\n", "color": "white"}, {"text": "duration:200", "color": "aqua"}, {"text": " is the whole travel in ticks. ", "color": "white"}, {"text": "ease:\"linear\"", "color": "aqua"}, {"text": " is how it moves between keyframes: ", "color": "white"}, {"text": "linear", "color": "yellow"}, {"text": " (constant speed), ", "color": "white"}, {"text": "ease_in", "color": "yellow"}, {"text": " (starts slow), ", "color": "white"}, {"text": "ease_out", "color": "yellow"}, {"text": " (ends slow), ", "color": "white"}, {"text": "ease_in_out", "color": "yellow"}, {"text": " (both).\n", "color": "white"}, {"text": "Every other option is written with its default value, ready to edit; ", "color": "white"}, {"text": "particle", "color": "green"}, {"text": " and ", "color": "white"}, {"text": "spline", "color": "green"}, {"text": " are left out (no trail, automatic curve): add them if you want one.\n", "color": "white"}, {"text": "The relative command flies the same path around its ", "color": "white"}, {"text": "positioned", "color": "green"}, {"text": " coordinates, which start on the first keyframe: change them to move the whole path.", "color": "white"}]}], "inputs": [{"type": "minecraft:text", "key": "absolute", "label": {"text": "Absolute positions", "color": "gold"}, "initial": "", "max_length": 32500, "width": 400, "multiline": {"max_lines": 64, "height": 80}}, {"type": "minecraft:text", "key": "relative", "label": {"text": "Positions relative to the first keyframe", "color": "aqua"}, "initial": "", "max_length": 32500, "width": 400, "multiline": {"max_lines": 64, "height": 80}}], "actions": [{"label": {"text": "Preview", "color": "green"}, "action": {"type": "minecraft:run_command", "command": "/function cinemalya:v1.1.0/editor/preview"}}, {"label": {"text": "Clear keyframes", "color": "red"}, "action": {"type": "minecraft:run_command", "command": "/function cinemalya:v1.1.0/editor/reset"}}], "columns": 2, "exit_action": {"label": "Close"}}
data modify storage cinemalya:editor dialog.inputs[0].initial set from storage cinemalya:editor export.abs
data modify storage cinemalya:editor dialog.inputs[1].initial set from storage cinemalya:editor export.rel
function cinemalya:v1.1.0/editor/export/show with storage cinemalya:editor

