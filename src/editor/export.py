""" Turning the recorded keyframes into a `launch_path` command, and replaying them.

No command turns a number into text, and a macro prints a nested double with all its binary noise
(`0.5700000000000001d`). So every coordinate goes through a score in hundredths, split into a sign,
an integer part and two digits, which a macro then glues back together as plain text.
"""
# Imports
import json

from stewbeet import write_versioned_function
from stouputils.typing import JsonDict

# Constants
EXPORT_DURATION: int = 200
""" Ticks the exported travel lasts. Nothing is timed while editing, so the player edits this in the command. """

EXPORT_EASE: str = "linear"
""" How the exported travel accelerates, written in the command so that changing it is one word: linear, ease_in, ease_out or ease_in_out. """

COMMAND_LENGTH: int = 32500
""" Longest text a command block accepts, and so the longest export worth showing. """

NUMBERS: tuple[str, ...] = ("x", "y", "z", "dx", "dy", "dz", "yaw", "pitch")
""" Every number a keyframe prints, each read from the score of the same name. """


# Functions
def format_number(ns: str, key: str) -> str:
	""" Commands splitting the score #key (in hundredths) into the export.key_* parts that `number` glues together. """
	part: str = f"storage {ns}:editor export.{key}"
	return f"""
data modify {part}_s set value ""
execute if score #{key} {ns}.data matches ..-1 run data modify {part}_s set value "-"
execute if score #{key} {ns}.data matches ..-1 run scoreboard players operation #{key} {ns}.data *= #-1 {ns}.data
scoreboard players operation #{key}_i {ns}.data = #{key} {ns}.data
execute store result {part}_i int 1 run scoreboard players operation #{key}_i {ns}.data /= #100 {ns}.data
execute store result {part}_f int 1 run scoreboard players operation #{key} {ns}.data %= #100 {ns}.data
data modify {part}_p set value ""
execute if score #{key} {ns}.data matches ..9 run data modify {part}_p set value "0"
"""


def number(key: str) -> str:
	""" Macro text printing a number split by `format_number`, ex: `-12.05`. """
	return f"$({key}_s)$({key}_i).$({key}_p)$({key}_f)"


def write_export(ns: str, version: str) -> None:
	""" The export dialog, the command text it shows, and the preview it offers. """
	major: str = version.split(".")[0]
	launch: str = f'function #{ns}:v{major}/launch_path {{with:{{duration:{EXPORT_DURATION},ease:"{EXPORT_EASE}",smoothing:2,delay:0,gamemode:"restore",precise_rotation:true,tags:[],waypoints:['
	dialog: JsonDict = {
		"type": "minecraft:multi_action",
		"title": {"text": "Cinemalya Export", "color": "gold", "bold": True},
		"body": [{"type": "minecraft:plain_message", "width": 400, "contents": [
			{"text": "Click a box, then ", "color": "white"}, {"text": "Ctrl+A", "color": "yellow"}, {"text": " and ", "color": "white"}, {"text": "Ctrl+C", "color": "yellow"},
			{"text": ", and paste it in a command block or a function: chat cuts commands at ", "color": "white"}, {"text": "256 characters", "color": "red"}, {"text": ".\n", "color": "white"},
			{"text": f"duration:{EXPORT_DURATION}", "color": "aqua"}, {"text": " is the whole travel in ticks. ", "color": "white"}, {"text": f'ease:"{EXPORT_EASE}"', "color": "aqua"},
			{"text": " is how it moves between keyframes: ", "color": "white"}, {"text": "linear", "color": "yellow"}, {"text": " (constant speed), ", "color": "white"},
			{"text": "ease_in", "color": "yellow"}, {"text": " (starts slow), ", "color": "white"}, {"text": "ease_out", "color": "yellow"}, {"text": " (ends slow), ", "color": "white"},
			{"text": "ease_in_out", "color": "yellow"}, {"text": " (both).\n", "color": "white"},
			{"text": "Every other option is written with its default value, ready to edit; ", "color": "white"}, {"text": "particle", "color": "green"}, {"text": " and ", "color": "white"}, {"text": "spline", "color": "green"},
			{"text": " are left out (no trail, automatic curve): add them if you want one.\n", "color": "white"},
			{"text": "The relative command flies the same path around its ", "color": "white"}, {"text": "positioned", "color": "green"},
			{"text": " coordinates, which start on the first keyframe: change them to move the whole path.", "color": "white"},
		]}],
		"inputs": [
			{"type": "minecraft:text", "key": key, "label": label, "initial": "", "max_length": COMMAND_LENGTH, "width": 400, "multiline": {"max_lines": 64, "height": 80}}
			for key, label in (("absolute", {"text": "Absolute positions", "color": "gold"}), ("relative", {"text": "Positions relative to the first keyframe", "color": "aqua"}))
		],
		"actions": [
			{"label": {"text": "Preview", "color": "green"}, "action": {"type": "minecraft:run_command", "command": f"/function {ns}:v{version}/editor/preview"}},
			{"label": {"text": "Clear keyframes", "color": "red"}, "action": {"type": "minecraft:run_command", "command": f"/function {ns}:v{version}/editor/reset"}},
		],
		"columns": 2,
		"exit_action": {"label": "Close"},
	}

	write_versioned_function("editor/export/main", f"""
#> main
#
# @executed			as the player
#
# @output storage	{ns}:editor export.abs, export.rel : the two commands, shown in a dialog
#

execute if score #keyframes {ns}.data matches ..1 run return run title @s actionbar {{text:"Place at least two keyframes to export",color:"red"}}
data modify storage {ns}:editor export set value {{abs:"",rel:"",sep:""}}
data modify storage {ns}:editor iter set from storage {ns}:editor keyframes
execute store result score #x0 {ns}.data run data get storage {ns}:editor keyframes[0].pos[0] 100
execute store result score #y0 {ns}.data run data get storage {ns}:editor keyframes[0].pos[1] 100
execute store result score #z0 {ns}.data run data get storage {ns}:editor keyframes[0].pos[2] 100
function {ns}:v{version}/editor/export/loop

## The relative command is positioned on the first keyframe
scoreboard players operation #x {ns}.data = #x0 {ns}.data
scoreboard players operation #y {ns}.data = #y0 {ns}.data
scoreboard players operation #z {ns}.data = #z0 {ns}.data
{"".join(format_number(ns, key) for key in ("x", "y", "z"))}
function {ns}:v{version}/editor/export/wrap with storage {ns}:editor export

data modify storage {ns}:editor dialog set value {json.dumps(dialog)}
data modify storage {ns}:editor dialog.inputs[0].initial set from storage {ns}:editor export.abs
data modify storage {ns}:editor dialog.inputs[1].initial set from storage {ns}:editor export.rel
function {ns}:v{version}/editor/export/show with storage {ns}:editor
""")

	write_versioned_function("editor/export/loop", f"""
execute store result score #x {ns}.data run data get storage {ns}:editor iter[0].pos[0] 100
execute store result score #y {ns}.data run data get storage {ns}:editor iter[0].pos[1] 100
execute store result score #z {ns}.data run data get storage {ns}:editor iter[0].pos[2] 100
execute store result score #yaw {ns}.data run data get storage {ns}:editor iter[0].rot[0] 100
execute store result score #pitch {ns}.data run data get storage {ns}:editor iter[0].rot[1] 100
scoreboard players operation #dx {ns}.data = #x {ns}.data
scoreboard players operation #dx {ns}.data -= #x0 {ns}.data
scoreboard players operation #dy {ns}.data = #y {ns}.data
scoreboard players operation #dy {ns}.data -= #y0 {ns}.data
scoreboard players operation #dz {ns}.data = #z {ns}.data
scoreboard players operation #dz {ns}.data -= #z0 {ns}.data
{"".join(format_number(ns, key) for key in NUMBERS)}
function {ns}:v{version}/editor/export/append with storage {ns}:editor export
data modify storage {ns}:editor export.sep set value ","
data remove storage {ns}:editor iter[0]
execute if data storage {ns}:editor iter[0] run function {ns}:v{version}/editor/export/loop
""")

	rot: str = f"{number('yaw')},{number('pitch')}"
	write_versioned_function("editor/export/append", f"""
$data modify storage {ns}:editor export.abs set value '$(abs)$(sep){{args:[{number("x")},{number("y")},{number("z")},{rot}]}}'
$data modify storage {ns}:editor export.rel set value '$(rel)$(sep){{at:"~{number("dx")} ~{number("dy")} ~{number("dz")}",rot:[{rot}]}}'
""")

	write_versioned_function("editor/export/wrap", f"""
$data modify storage {ns}:editor export.abs set value 'execute as @a run {launch}$(abs)]}}}}'
$data modify storage {ns}:editor export.rel set value 'execute as @a positioned {number("x")} {number("y")} {number("z")} run {launch}$(rel)]}}}}'
""")

	write_versioned_function("editor/export/show", """
$dialog show @s $(dialog)
""")

	write_versioned_function("editor/preview", f"""
#> preview
#
# @executed			as & at the player
#
# @description		Fly the player along the keyframes, timed like the exported command.
#

execute if score #keyframes {ns}.data matches ..1 run return run title @s actionbar {{text:"Place at least two keyframes to preview",color:"red"}}
data modify storage {ns}:editor preview set value {{with:{{duration:{EXPORT_DURATION}}}}}
data modify storage {ns}:editor preview.with.waypoints set from storage {ns}:editor keyframes
function {ns}:v{version}/travel/from_waypoints with storage {ns}:editor preview
""")

