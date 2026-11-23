""" A mannequin dressed as the player, standing where the camera is, for everyone else to see.

A spectator has no body, so without it the others watch an empty room while the player flies through it.
"""
# Imports
from stewbeet import Mem, write_versioned_function

# Constants
EYE_HEIGHTS: dict[str, float] = {
	"standing": 1.62,
	"crouching": 1.27,
	"swimming": 0.4,
	"fall_flying": 0.4,
}
""" Pose a mannequin accepts -> height of its eyes over its feet, which is how far under the camera it stands. """

BACKOFF: float = 1.0
""" Blocks the mannequin stands behind the camera. Closer, the spectator looks at the inside of their own head, down to a pitch of 60. """


# Functions
def write_double(ns: str, version: str) -> None:
	""" Choosing the pose, dressing the mannequin, keeping it under the camera and getting rid of it. """
	pose_lines: str = "".join(
		f'execute if data storage {ns}:work args{{pose:"{pose}"}} run data modify storage {ns}:work double.pose set value "{pose}"\n'
		for pose in EYE_HEIGHTS
	)
	write_versioned_function("travel/double/choose", f"""
#> choose
#
# @output storage	{ns}:work double.pose : the pose asked for in `pose`, standing when it is missing or unknown
#

data modify storage {ns}:work double set value {{pose:"standing"}}
{pose_lines}""")

	write_versioned_function("travel/double/spawn", f"""
#> spawn
#
# @executed			as & at the player, whose id is already the cinematic's
#
# @description		Summon a mannequin with the player's skin, armor and hands. Its skin is read off a player head
#					filled by the player, since a mannequin cannot take it from a player directly.
#

function {ns}:v{version}/travel/double/summon with storage {ns}:work double
item replace entity @n[type=mannequin,tag={ns}.new] weapon.mainhand with minecraft:player_head
item modify entity @n[type=mannequin,tag={ns}.new] weapon.mainhand {{type:"minecraft:fill_player_head",entity:"this"}}
data modify entity @n[type=mannequin,tag={ns}.new] profile set from entity @n[type=mannequin,tag={ns}.new] equipment.mainhand.components."minecraft:profile"
data modify entity @n[type=mannequin,tag={ns}.new] equipment set from entity @s equipment
data remove entity @n[type=mannequin,tag={ns}.new] equipment.saddle
data modify entity @n[type=mannequin,tag={ns}.new] equipment.mainhand set from entity @s SelectedItem
scoreboard players operation @n[type=mannequin,tag={ns}.new] {ns}.id = @s {ns}.id
tag @n[type=mannequin,tag={ns}.new] add {ns}.double
tag @n[type=mannequin,tag={ns}.new] remove {ns}.new
""")

	write_versioned_function("travel/double/summon", f"""
$summon mannequin ~ ~ ~ {{Tags:["{ns}.new","{ns}.pose_$(pose)"],pose:"$(pose)",hide_description:1b,immovable:1b,NoGravity:1b,Invulnerable:1b,Silent:1b}}
""")

	lowering: str = "".join(
		f"execute if entity @s[tag={ns}.pose_{pose}] rotated ~ 0 run tp @s ^ ^-{height} ^-{BACKOFF}\n"
		for pose, height in EYE_HEIGHTS.items()
	)
	write_versioned_function("playback/move_double", f"""
#> move_double
#
# @executed			as & at the cinematic entity, whose id #player_id {ns}.id holds
#
# @description		Stand the mannequin under the camera, looking where it looks.
#

tp @e[type=mannequin,tag={ns}.double,predicate={ns}:has_same_id,limit=1] @s
execute as @e[type=mannequin,tag={ns}.double,predicate={ns}:has_same_id,limit=1] at @s run function {ns}:v{version}/playback/lower_double
""")

	write_versioned_function("playback/lower_double", f"""
#> lower_double
#
# @executed			as & at the mannequin, standing on the camera
#
# @description		Eyes are where the camera is, so the feet are one eye height lower, and a block behind it so the camera is not inside the head.
#

{lowering}""")

	write_versioned_function("playback/remove_double", f"""
#> remove_double
#
# @executed			as the cinematic entity
#

scoreboard players operation #player_id {ns}.id = @s {ns}.id
kill @e[type=mannequin,tag={ns}.double,predicate={ns}:has_same_id]
""")


def main() -> None:
	""" Write everything that gives the player a visible body. """
	write_double(Mem.ctx.project_id, Mem.ctx.project_version)

