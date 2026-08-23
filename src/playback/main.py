# Imports
from stewbeet import Mem, write_versioned_function


def write_tick(ns: str, version: str) -> None:
	""" The per-tick loop: find the rider, keep them looking through the camera, advance a frame. """
	write_versioned_function("playback/tick", f"""
#> tick
#
# @executed			as & at every cinematic entity
#
# @description		Resolve the player riding this cinematic, then advance it by one tick.
#

# A free flying camera has nobody to carry along
execute if entity @s[tag={ns}.detached] run return run function {ns}:v{version}/playback/advance

# Tag the rider, storing success so the same selector also tells us whether they are still online
scoreboard players operation #player_id {ns}.id = @s {ns}.id
execute store success score #found {ns}.data run tag @a[predicate={ns}:has_same_id,limit=1] add {ns}.temp
execute if score #found {ns}.data matches 0 run return run function {ns}:v{version}/playback/kill

execute at @a[tag={ns}.temp,limit=1] run function {ns}:v{version}/playback/at_player
tag @a[tag={ns}.temp,limit=1] remove {ns}.temp
""")

	write_versioned_function("playback/at_player", f"""
#> at_player
#
# @executed			as the cinematic entity & at its rider
#
# @description		Keep the player glued to the camera. Re-issuing /spectate every tick is what
#					survives a death, a dimension change, or the player pressing a movement key.
#

tp @a[distance=0,tag={ns}.temp,limit=1] @s
execute at @s run spectate @s @a[distance=0,tag={ns}.temp,limit=1]
function {ns}:v{version}/playback/advance
""")

	write_versioned_function("playback/advance", f"""
#> advance
#
# @executed			as & at the cinematic entity
#
# @description		Burn a tick of the opening delay, or step onto the next frame once enough ticks
#					have passed for the client to have finished interpolating the previous one.
#

# Hold still while the opening delay runs down
execute if score @s {ns}.delay matches 1.. run return run scoreboard players remove @s {ns}.delay 1

# Only move once per `smoothing` ticks
scoreboard players add @s {ns}.frame 1
execute if score @s {ns}.frame < @s {ns}.smoothing run return 0
scoreboard players set @s {ns}.frame 0

execute store result storage {ns}:work sel.i int 1 run scoreboard players get @s {ns}.id
function {ns}:v{version}/playback/pop with storage {ns}:work sel
""")

	write_versioned_function("playback/pop", f"""
#> pop
#
# @executed			as & at the cinematic entity
# @input macro		i : int - the cinematic id
#
# @description		Take the next frame off this cinematic's path and move onto it. Popping keeps the
#					work per tick constant no matter how long the path is.
#

$data modify entity @s Pos set from storage {ns}:work paths.i$(i).points[0]
$data remove storage {ns}:work paths.i$(i).points[0]
$data modify entity @s Rotation set from storage {ns}:work paths.i$(i).rotations[0]
$data remove storage {ns}:work paths.i$(i).rotations[0]
execute if entity @s[tag={ns}.particle] run function {ns}:v{version}/playback/particle
$execute unless data storage {ns}:work paths.i$(i).points[0] run function {ns}:v{version}/playback/finish
""")

	write_versioned_function("playback/particle", f"""
#> particle
#
# @executed			as the cinematic entity
#

data modify storage {ns}:work trail set from entity @s item.components."minecraft:custom_data"
execute at @s run function {ns}:v{version}/playback/spawn_particle with storage {ns}:work trail
""")

	write_versioned_function("playback/spawn_particle", """
$particle $(particle) ~ ~ ~ 0.2 0.2 0.2 0 2
""")


def write_ending(ns: str, version: str) -> None:
	""" Everything that ends a cinematic: reaching the end, aborting it, and cleaning up after it. """
	write_versioned_function("playback/finish", f"""
#> finish
#
# @executed			as & at the cinematic entity
#
# @description		The path ran out: put the rider down and dispose of the camera.
#

execute unless entity @s[tag={ns}.detached] run function {ns}:v{version}/playback/release
function {ns}:v{version}/playback/kill
""")

	write_versioned_function("playback/release", f"""
#> release
#
# @executed			as & at the cinematic entity, with the rider tagged {ns}.temp
#
# @description		Drop the player where the camera stopped, at their feet rather than their eyes,
#					give them their gamemode back, then let other datapacks react.
#

execute at @s run tp @a[tag={ns}.temp,limit=1] ~ ~-1.6 ~ ~ ~
execute at @s positioned ~ ~-1.6 ~ run function {ns}:v{version}/playback/restore_gamemode
execute at @s positioned ~ ~-1.6 ~ as @a[distance=0,tag={ns}.temp,limit=1] at @s run function #{ns}:v1/signals/on_finish
""")

	write_versioned_function("playback/restore_gamemode", f"""
#> restore_gamemode
#
# @executed			as the cinematic entity, with the rider tagged {ns}.temp
#
# @description		Put the player back in whatever gamemode they were in when the cinematic started.
#

execute if entity @s[tag={ns}.keep_gamemode] run return 0
execute if entity @s[tag={ns}.was_survival] run gamemode survival @a[distance=0,tag={ns}.temp,limit=1]
execute if entity @s[tag={ns}.was_adventure] run gamemode adventure @a[distance=0,tag={ns}.temp,limit=1]
execute if entity @s[tag={ns}.was_creative] run gamemode creative @a[distance=0,tag={ns}.temp,limit=1]
""")

	write_versioned_function("playback/kill", f"""
#> kill
#
# @executed			as the cinematic entity
#
# @description		Dispose of the camera and the path it was flying, keeping #entities in step.
#

scoreboard players remove #entities {ns}.data 1
execute store result storage {ns}:work sel.i int 1 run scoreboard players get @s {ns}.id
function {ns}:v{version}/playback/clear_path with storage {ns}:work sel
kill @s
""")

	write_versioned_function("playback/clear_path", f"""
$data remove storage {ns}:work paths.i$(i)
""")


def write_stop(ns: str, version: str) -> None:
	""" The public abort, plus the silent one a fresh launch uses to clear the way. """
	write_versioned_function("playback/stop", f"""
#> stop
#
# @executed			as the player
#
# @input macro		with : compound - {{restore: bool}}, whether to hand the gamemode back (default: true)
#
# @description		End the cinematic the player is riding, if any. The player is left exactly where
#					the camera was, so the caller decides where they actually belong.
#

$data modify storage {ns}:work stop set value $(with)
scoreboard players set #restore {ns}.data 1
execute if data storage {ns}:work stop{{restore:false}} run scoreboard players set #restore {ns}.data 0
function {ns}:v{version}/playback/stop_for_player
""")

	write_versioned_function("playback/stop_silent", f"""
#> stop_silent
#
# @executed			as the player
#
# @description		Clear any cinematic still running for this player, leaving their gamemode alone:
#					the launch about to happen is what decides where they end up.
#

scoreboard players set #restore {ns}.data 0
function {ns}:v{version}/playback/stop_for_player
""")

	write_versioned_function("playback/stop_for_player", f"""
#> stop_for_player
#
# @executed			as the player
#
# @description		A player who never rode a cinematic has no id at all, and copying an unset score
#					leaves #player_id on its previous value, which would target somebody else's camera.
#

execute unless score @s {ns}.id = @s {ns}.id run return 0
scoreboard players operation #player_id {ns}.id = @s {ns}.id
tag @s add {ns}.temp
execute as @e[type=item_display,tag={ns}.cinematic,predicate={ns}:has_same_id] run function {ns}:v{version}/playback/stop_one
tag @s remove {ns}.temp
""")

	write_versioned_function("playback/stop_one", f"""
execute if score #restore {ns}.data matches 1 run function {ns}:v{version}/playback/restore_gamemode
function {ns}:v{version}/playback/kill
""")


def main() -> None:
	""" Write the playback loop and every way a cinematic can end. """
	ns: str = Mem.ctx.project_id
	version: str = Mem.ctx.project_version

	write_tick(ns, version)
	write_ending(ns, version)
	write_stop(ns, version)
