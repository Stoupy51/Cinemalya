# Imports
from stewbeet import Mem, write_versioned_function

from .control import write_control
from .frames import write_frames
from .sampling import write_sampling
from .waypoints import write_waypoints


def write_entry_points(ns: str, version: str) -> None:
	""" The three ways to start a travel, each ending on the shared start routine. """
	write_versioned_function("travel/from_coords", f"""
#> from_coords
#
# @executed			as & at the player
#
# @input macro		with : compound - see the launch documentation in the README
#
# @description		Fly the player from where they stand to the given coordinates.
#					x/y/z are where the player ends up standing, not where the camera stops.
#

$data modify storage {ns}:work args set value $(with)
function {ns}:v{version}/travel/defaults
function {ns}:v{version}/travel/waypoints/start_here
function {ns}:v{version}/travel/waypoints/target_from_coords
function {ns}:v{version}/travel/start
""")

	write_versioned_function("travel/from_entity", f"""
#> from_entity
#
# @executed			as & at the player
#
# @input macro		with : compound - see the launch_at_entity documentation in the README
#
# @description		Fly the player from where they stand to another entity's position and rotation.
#

$data modify storage {ns}:work args set value $(with)
function {ns}:v{version}/travel/defaults
function {ns}:v{version}/travel/waypoints/start_here
function {ns}:v{version}/travel/waypoints/target_from_entity
function {ns}:v{version}/travel/start
""")

	write_versioned_function("travel/from_here", f"""
#> from_here
#
# @executed			as the player, positioned & rotated wherever the caller aimed
#
# @input macro		with : compound - see the launch_here documentation in the README
#
# @description		Fly the player to the execution position and rotation, so the destination can be
#					written with `~` and `^` coordinates. A command block never needs absolute numbers.
#

$data modify storage {ns}:work args set value $(with)
function {ns}:v{version}/travel/defaults
function {ns}:v{version}/travel/waypoints/start_here
function {ns}:v{version}/travel/waypoints/target_here
function {ns}:v{version}/travel/start
""")

	write_versioned_function("travel/from_waypoints", f"""
#> from_waypoints
#
# @executed			as & at the player, or anywhere at all for a detached camera
#
# @input macro		with : compound - see the launch_path documentation in the README
#
# @description		Fly along an explicit list of camera waypoints.
#					A single waypoint is completed with the player's own position as the starting one.
#

$data modify storage {ns}:work args set value $(with)
function {ns}:v{version}/travel/defaults
execute unless data storage {ns}:work args.waypoints[0] run return fail
execute unless data storage {ns}:work args.waypoints[1] unless score #mode {ns}.data matches 2 run function {ns}:v{version}/travel/waypoints/prepend_here
execute unless data storage {ns}:work args.waypoints[1] run return fail
function {ns}:v{version}/travel/start
""")


def write_defaults(ns: str) -> None:
	""" Fill in every optional argument, then turn the string options into scores to branch on. """
	write_versioned_function("travel/defaults", f"""
#> defaults
#
# @output score		#duration, #smoothing, #mode, #ease_path {ns}.data
#
# @description		Complete the caller's arguments so the rest of the pipeline never tests for absence.
#

## Optional arguments
execute unless data storage {ns}:work args.duration run data modify storage {ns}:work args.duration set value 60
execute unless data storage {ns}:work args.smoothing run data modify storage {ns}:work args.smoothing set value 2
execute unless data storage {ns}:work args.delay run data modify storage {ns}:work args.delay set value 0
execute unless data storage {ns}:work args.arc_side run data modify storage {ns}:work args.arc_side set value 0.0
execute unless data storage {ns}:work args.arc_height run data modify storage {ns}:work args.arc_height set value 20.0
execute unless data storage {ns}:work args.tags run data modify storage {ns}:work args.tags set value []

## Easing curve asked for by the whole path, spread across its segments later on
scoreboard players set #ease_path {ns}.data 0
execute if data storage {ns}:work args{{ease:"ease_in"}} run scoreboard players set #ease_path {ns}.data 1
execute if data storage {ns}:work args{{ease:"ease_out"}} run scoreboard players set #ease_path {ns}.data 2
execute if data storage {ns}:work args{{ease:"ease_in_out"}} run scoreboard players set #ease_path {ns}.data 3

## Full precision rotation packets, on unless the caller opted out
scoreboard players set #precise {ns}.data 1
execute if data storage {ns}:work args{{precise_rotation:false}} run scoreboard players set #precise {ns}.data 0

## What to do with the player's gamemode (0 = remember and restore, 1 = leave alone, 2 = no player at all)
scoreboard players set #mode {ns}.data 0
execute if data storage {ns}:work args{{gamemode:"keep"}} run scoreboard players set #mode {ns}.data 1
execute if data storage {ns}:work args{{gamemode:"none"}} run scoreboard players set #mode {ns}.data 2

## Timing, clamped so a zero can never divide anything later on
execute store result score #duration {ns}.data run data get storage {ns}:work args.duration
execute store result score #smoothing {ns}.data run data get storage {ns}:work args.smoothing
execute if score #duration {ns}.data matches ..0 run scoreboard players set #duration {ns}.data 1
execute if score #smoothing {ns}.data matches ..0 run scoreboard players set #smoothing {ns}.data 1
""")


def write_start(ns: str, version: str) -> None:
	""" Turn the resolved arguments into a sampled path and the entity that flies it. """
	write_versioned_function("travel/start", f"""
#> start
#
# @executed			as & at the player, or anywhere at all for a detached camera
#
# @description		Build the path, then summon the display entity that carries the player along it.
#

# One cinematic per player: a second launch replaces the first instead of fighting over the camera
execute unless score #mode {ns}.data matches 2 run function {ns}:v{version}/playback/stop_silent

## Build the path
function {ns}:v{version}/travel/waypoints/normalize
function {ns}:v{version}/travel/control/main
function {ns}:v{version}/travel/sample/main
function {ns}:v{version}/travel/frames/main

## Hand over to the entity, tagging the player so the summoned entity can find them
execute unless score #mode {ns}.data matches 2 run function #{ns}:v1/signals/on_launch
execute unless score #mode {ns}.data matches 2 run tag @s add {ns}.temp
execute summon item_display run function {ns}:v{version}/travel/spawn
execute unless score #mode {ns}.data matches 2 run tag @s remove {ns}.temp
""")

	write_versioned_function("travel/spawn", f"""
#> spawn
#
# @executed			as the freshly summoned item_display & at the launch position
#
# @description		Register the cinematic, store its path, then attach the player to it.
#

## Identity and conventions
scoreboard players add #next_id {ns}.id 1
scoreboard players operation @s {ns}.id = #next_id {ns}.id
scoreboard players add #entities {ns}.data 1
tag @s add {ns}.cinematic
tag @s add smithed.entity
tag @s add smithed.strict
tag @s add global.ignore
tag @s add global.ignore.kill
execute if score #precise {ns}.data matches 1 run tag @s add {ns}.precise
function {ns}:v{version}/travel/tags/main

## Timing state, and the client-side interpolation that hides the per-frame jumps
scoreboard players operation @s {ns}.smoothing = #smoothing {ns}.data
scoreboard players set @s {ns}.frame 0
execute store result score @s {ns}.delay run data get storage {ns}:work args.delay
execute store result entity @s teleport_duration int 1 run scoreboard players get #smoothing {ns}.data

## Start on the first waypoint, holding an item that renders nothing
data modify entity @s Pos set from storage {ns}:work args.waypoints[0].pos
data modify entity @s Rotation set from storage {ns}:work args.waypoints[0].rot
data modify entity @s item set value {{id:"minecraft:stone",count:1,components:{{"minecraft:item_model":"minecraft:air"}}}}
execute if data storage {ns}:work args.particle run function {ns}:v{version}/travel/set_particle

## Give this cinematic its own slot in the path storage
execute store result storage {ns}:work sel.i int 1 run scoreboard players get @s {ns}.id
function {ns}:v{version}/travel/store_path with storage {ns}:work sel

## Attach the player, unless this is a free flying camera
execute if score #mode {ns}.data matches 2 run tag @s add {ns}.detached
execute if score #mode {ns}.data matches 1 run tag @s add {ns}.keep_gamemode
execute unless score #mode {ns}.data matches 2 run function {ns}:v{version}/travel/attach
""")

	write_versioned_function("travel/store_path", f"""
#> store_path
#
# @input macro		i : int - the cinematic id
#
# @description		Move the freshly built frame lists into this cinematic's own storage slot.
#

$data modify storage {ns}:work paths.i$(i) set value {{}}
$data modify storage {ns}:work paths.i$(i).points set from storage {ns}:work frames.points
$data modify storage {ns}:work paths.i$(i).rotations set from storage {ns}:work frames.rotations
""")

	write_versioned_function("travel/set_particle", f"""
#> set_particle
#
# @executed			as the cinematic entity
#
# @description		Remember the particle to trail behind the camera. The tag keeps playback from reading NBT for nothing.
#

tag @s add {ns}.particle
data modify entity @s item.components."minecraft:custom_data".particle set from storage {ns}:work args.particle
""")

	write_versioned_function("travel/attach", f"""
#> attach
#
# @executed			as the cinematic entity
#
# @description		Bind the launching player to this cinematic and hand them over to the camera.
#

execute unless entity @s[tag={ns}.keep_gamemode] run function {ns}:v{version}/travel/remember_gamemode
scoreboard players operation @p[tag={ns}.temp] {ns}.id = @s {ns}.id
gamemode spectator @p[tag={ns}.temp]
spectate @s @p[tag={ns}.temp]
""")

	write_versioned_function("travel/remember_gamemode", f"""
#> remember_gamemode
#
# @executed			as the cinematic entity
#
# @description		Store the player's gamemode on the entity, so it survives them disconnecting mid-flight.
#

execute if entity @p[tag={ns}.temp,gamemode=survival] run tag @s add {ns}.was_survival
execute if entity @p[tag={ns}.temp,gamemode=adventure] run tag @s add {ns}.was_adventure
execute if entity @p[tag={ns}.temp,gamemode=creative] run tag @s add {ns}.was_creative
""")


def write_extra_tags(ns: str, version: str) -> None:
	""" Copy the caller's own tags onto the cinematic entity, one macro per tag. """
	write_versioned_function("travel/tags/main", f"""
#> main
#
# @executed			as the cinematic entity
#
# @description		Apply every tag the caller asked for on top of the conventional ones.
#

execute store result score #tag_count {ns}.data run data get storage {ns}:work args.tags
scoreboard players set #t {ns}.data 0
function {ns}:v{version}/travel/tags/loop
""")

	write_versioned_function("travel/tags/loop", f"""
execute if score #t {ns}.data < #tag_count {ns}.data run function {ns}:v{version}/travel/tags/one
""")

	write_versioned_function("travel/tags/one", f"""
execute store result storage {ns}:work sel.i int 1 run scoreboard players get #t {ns}.data
function {ns}:v{version}/travel/tags/read with storage {ns}:work sel
function {ns}:v{version}/travel/tags/apply with storage {ns}:work one_tag
scoreboard players add #t {ns}.data 1
function {ns}:v{version}/travel/tags/loop
""")

	write_versioned_function("travel/tags/read", f"""
$data modify storage {ns}:work one_tag.name set from storage {ns}:work args.tags[$(i)]
""")

	write_versioned_function("travel/tags/apply", """
$tag @s add $(name)
""")


def main() -> None:
	""" Write everything that turns a call into a flying camera. """
	ns: str = Mem.ctx.project_id
	version: str = Mem.ctx.project_version

	write_entry_points(ns, version)
	write_defaults(ns)
	write_waypoints(ns, version)
	write_control(ns, version)
	write_sampling(ns, version)
	write_frames(ns, version)
	write_start(ns, version)
	write_extra_tags(ns, version)
