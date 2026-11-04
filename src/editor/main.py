""" The keyframe editor: an item that records camera waypoints where its holder stands and looks.

Right click places a keyframe, left click removes the last one, sneaking and right clicking previews the path,
and dropping the item opens the export. Every editor shares one path, kept in `<ns>:editor keyframes`.
"""
# ruff: noqa: E501
# Imports
from beet import Enchantment
from stewbeet import Mem, write_versioned_function

from ..limits import MAX_WAYPOINTS
from .export import write_export

# Constants
LEFT_CLICK_ENCHANTMENT: str = "editor_left_click"
""" Not versioned: its id is baked into every editor item a player holds, only the function it runs is. """

TRAIL_PERIOD: int = 10
""" Ticks between two dots sent down each segment of the trail. """

TRAIL_COLOR: int = 0xFFC832
""" Gold, as an RGB int. """


# Functions
def editor_item(ns: str) -> str:
	""" The editor item, as `give` and `if items` take it.

	A zero reach piercing weapon turns every left click, even at air, into a piercing attack whose
	enchantment effect runs the remove function. `tool` keeps that click from breaking blocks in creative.
	"""
	lore: str = ",".join(
		f'[{{text:"{key}",color:"yellow",italic:false}},{{text:": {action}",color:"white",italic:false}}]'
		for key, action in (
			("Right click", "place a keyframe"),
			("Left click", "remove the last one"),
			("Sneak + right click", "preview"),
			("Drop", "export the command"),
		)
	)
	return (
		f"minecraft:carrot_on_a_stick[custom_data={{{ns}:{{editor:true}}}},"
		f'item_name={{text:"Cinemalya Editor",color:"gold"}},item_model="minecraft:spyglass",lore=[{lore}],'
		"piercing_weapon={},attack_range={min_reach:0.0f,max_reach:0.0f,min_creative_reach:0.0f,max_creative_reach:0.0f,hitbox_margin:0.0f},"
		f'enchantments={{"{ns}:{LEFT_CLICK_ENCHANTMENT}":1}},enchantment_glint_override=false,'
		'tooltip_display={hidden_components:["minecraft:enchantments"]},tool={rules:[],can_destroy_blocks_in_creative:false}]'
	)


def write_session(ns: str, version: str) -> None:
	""" Handing the item out, taking it back, and reading its clicks. """
	is_editor_item: str = f"*[custom_data~{{{ns}:{{editor:true}}}}]"

	write_versioned_function("editor/start", f"""
#> start
#
# @executed			as the player
#
# @description		Give the player the editor item and start reading its clicks.
#					A stale click score from any other carrot on a stick would otherwise place a keyframe at once.
#

execute if entity @s[tag={ns}.editor] run return fail
tag @s add {ns}.editor
scoreboard players add #editors {ns}.data 1
scoreboard players reset @s {ns}.click
scoreboard players reset @s {ns}.drop
execute unless data storage {ns}:editor keyframes run data modify storage {ns}:editor keyframes set value []
execute store result score #keyframes {ns}.data run data get storage {ns}:editor keyframes
give @s {editor_item(ns)}
""")

	write_versioned_function("editor/stop", f"""
#> stop
#
# @executed			as the player
#
# @description		Take the editor item back. The last editor to stop also clears the shared path.
#

execute unless entity @s[tag={ns}.editor] run return fail
tag @s remove {ns}.editor
scoreboard players remove #editors {ns}.data 1
clear @s {is_editor_item}
execute if score #editors {ns}.data matches ..0 run function {ns}:v{version}/editor/reset
""")

	write_versioned_function("editor/reset", f"""
#> reset
#
# @description		Forget every keyframe and take their numbers down.
#

kill @e[type=text_display,tag={ns}.keyframe]
data modify storage {ns}:editor keyframes set value []
data modify storage {ns}:editor trail set value []
scoreboard players set #keyframes {ns}.data 0
""")

	write_versioned_function("editor/tick", f"""
#> tick
#
# @description		Runs only while someone is editing, gated by #editors in the tick function.
#

execute as @a[tag={ns}.editor] run function {ns}:v{version}/editor/player
scoreboard players add #trail_clock {ns}.data 1
execute if score #trail_clock {ns}.data matches {TRAIL_PERIOD}.. run function {ns}:v{version}/editor/trail/draw
""")

	write_versioned_function("editor/player", f"""
execute if score @s {ns}.click matches 1.. at @s run function {ns}:v{version}/editor/on_use
execute if score @s {ns}.drop matches 1.. at @s run function {ns}:v{version}/editor/on_drop
""")

	write_versioned_function("editor/on_use", f"""
#> on_use
#
# @executed			as & at the player
#
# @description		The click score counts every carrot on a stick, so the hand is checked here.
#

scoreboard players reset @s {ns}.click
execute unless items entity @s weapon.mainhand {is_editor_item} run return 0
execute if predicate {{type:"minecraft:entity_properties",entity:"this",predicate:{{flags:{{is_sneaking:true}}}}}} run return run function {ns}:v{version}/editor/preview
function {ns}:v{version}/editor/place
""")

	write_versioned_function("editor/on_drop", f"""
#> on_drop
#
# @executed			as & at the player
#
# @description		The drop really happens (there is no key event), so the item is handed back before exporting.
#					It goes back in the hand when that is free, otherwise the player picks it up again.
#

scoreboard players reset @s {ns}.drop
tag @s add {ns}.dropper
execute as @e[type=item,distance=..4] if items entity @s contents {is_editor_item} run function {ns}:v{version}/editor/take_back
tag @s remove {ns}.dropper
function {ns}:v{version}/editor/export/main
""")

	write_versioned_function("editor/take_back", f"""
#> take_back
#
# @executed			as the dropped editor item
#

execute unless items entity @p[tag={ns}.dropper] weapon.mainhand * run return run function {ns}:v{version}/editor/to_hand
data modify entity @s PickupDelay set value 0s
""")

	write_versioned_function("editor/to_hand", f"""
item replace entity @p[tag={ns}.dropper] weapon.mainhand from entity @s contents
kill @s
""")

	Mem.ctx.data[ns].enchantments[LEFT_CLICK_ENCHANTMENT] = Enchantment({
		"description": "",
		"max_level": 1,
		"slots": ["hand"],
		"supported_items": [],
		"weight": 1,
		"anvil_cost": 0,
		"min_cost": {"base": 0, "per_level_above_first": 0},
		"max_cost": {"base": 0, "per_level_above_first": 0},
		"effects": {"minecraft:post_piercing_attack": [
			{"effect": {"type": "minecraft:run_function", "function": f"{ns}:v{version}/editor/remove_last"}},
		]},
	})


def write_keyframes(ns: str, version: str) -> None:
	""" Adding and removing keyframes, each with its number floating where the camera will be. """
	write_versioned_function("editor/place", f"""
#> place
#
# @executed			as & at the player
#
# @description		Record the player's eyes and rotation as the next keyframe. Sneaking lowers the eyes, so
#					the eye anchor is read off the number display rather than computed from the feet.
#

execute if score #keyframes {ns}.data matches {MAX_WAYPOINTS}.. run return run title @s actionbar {{text:"The path is full ({MAX_WAYPOINTS} keyframes)",color:"red"}}
scoreboard players add #keyframes {ns}.data 1
execute store result storage {ns}:editor label.n int 1 run scoreboard players get #keyframes {ns}.data
execute anchored eyes positioned ^ ^ ^ summon text_display run function {ns}:v{version}/editor/label
data modify storage {ns}:editor new.rot set from entity @s Rotation
data modify storage {ns}:editor keyframes append from storage {ns}:editor new
execute if score #keyframes {ns}.data matches 2.. run function {ns}:v{version}/editor/trail/add
title @s actionbar [{{text:"Keyframe ",color:"gold"}},{{score:{{name:"#keyframes",objective:"{ns}.data"}},color:"yellow"}},{{text:" placed",color:"gold"}}]
playsound minecraft:ui.button.click master @s ~ ~ ~ 0.5 1.6
""")

	write_versioned_function("editor/label", f"""
#> label
#
# @executed			as the number display, summoned on the player's eyes
#
# @output storage	{ns}:editor new : {{pos:[x,y,z]}}, the keyframe being placed
#

tag @s add {ns}.keyframe
scoreboard players operation @s {ns}.data = #keyframes {ns}.data
data modify entity @s billboard set value "center"
data modify entity @s see_through set value 1b
function {ns}:v{version}/editor/label_text with storage {ns}:editor label
data modify storage {ns}:editor new set value {{}}
data modify storage {ns}:editor new.pos set from entity @s Pos
""")

	write_versioned_function("editor/label_text", """
$data modify entity @s text set value {text:"$(n)",color:"gold",bold:true}
""")

	write_versioned_function("editor/remove_last", f"""
#> remove_last
#
# @executed			as & at the player who left clicked, from the editor item's enchantment
#

execute unless entity @s[tag={ns}.editor] run return 0
execute unless items entity @s weapon.mainhand *[custom_data~{{{ns}:{{editor:true}}}}] run return 0
execute if score #keyframes {ns}.data matches ..0 run return run title @s actionbar {{text:"No keyframe to remove",color:"red"}}
execute as @e[type=text_display,tag={ns}.keyframe] if score @s {ns}.data = #keyframes {ns}.data run kill @s
data remove storage {ns}:editor keyframes[-1]
execute if score #keyframes {ns}.data matches 2.. run data remove storage {ns}:editor trail[-1]
scoreboard players remove #keyframes {ns}.data 1
title @s actionbar [{{text:"Keyframe removed, ",color:"gold"}},{{score:{{name:"#keyframes",objective:"{ns}.data"}},color:"yellow"}},{{text:" left",color:"gold"}}]
playsound minecraft:ui.button.click master @s ~ ~ ~ 0.5 0.8
""")


def write_trail(ns: str, version: str) -> None:
	""" A dotted line flowing from each keyframe to the next, sent only to the editors. """
	write_versioned_function("editor/trail/add", f"""
#> add
#
# @description		Store the segment ending on the newest keyframe, so drawing never has to pair keyframes up.
#

data modify storage {ns}:editor segment set value {{}}
data modify storage {ns}:editor segment.x set from storage {ns}:editor keyframes[-2].pos[0]
data modify storage {ns}:editor segment.y set from storage {ns}:editor keyframes[-2].pos[1]
data modify storage {ns}:editor segment.z set from storage {ns}:editor keyframes[-2].pos[2]
data modify storage {ns}:editor segment.tx set from storage {ns}:editor keyframes[-1].pos[0]
data modify storage {ns}:editor segment.ty set from storage {ns}:editor keyframes[-1].pos[1]
data modify storage {ns}:editor segment.tz set from storage {ns}:editor keyframes[-1].pos[2]
data modify storage {ns}:editor trail append from storage {ns}:editor segment
""")

	write_versioned_function("editor/trail/draw", f"""
#> draw
#
# @description		Each dot lives for {TRAIL_PERIOD * 4} ticks while it travels its segment, so four of them
#					are always on the way and the line reads as flowing from the first keyframe to the last.
#

scoreboard players set #trail_clock {ns}.data 0
execute unless data storage {ns}:editor trail[0] run return 0
data modify storage {ns}:editor drawing set from storage {ns}:editor trail
function {ns}:v{version}/editor/trail/loop
""")

	write_versioned_function("editor/trail/loop", f"""
function {ns}:v{version}/editor/trail/dot with storage {ns}:editor drawing[0]
data remove storage {ns}:editor drawing[0]
execute if data storage {ns}:editor drawing[0] run function {ns}:v{version}/editor/trail/loop
""")

	write_versioned_function("editor/trail/dot", f"""
$particle minecraft:trail{{target:[$(tx),$(ty),$(tz)],color:{TRAIL_COLOR},duration:{TRAIL_PERIOD * 4}}} $(x) $(y) $(z) 0 0 0 0 1 force @a[tag={ns}.editor]
""")


def main() -> None:
	""" Write the editor item, its keyframes, its trail and its export. """
	ns: str = Mem.ctx.project_id
	version: str = Mem.ctx.project_version

	write_session(ns, version)
	write_keyframes(ns, version)
	write_trail(ns, version)
	write_export(ns, version)

