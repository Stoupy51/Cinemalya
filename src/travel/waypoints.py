# Imports
from stewbeet import write_versioned_function

from ..limits import MAX_DURATION


def write_capture(ns: str, version: str) -> None:
	""" Read back where and which way the caller was executing, so relative coordinates can be resolved. """
	write_versioned_function("travel/waypoints/look_ahead", f"""
#> look_ahead
#
# @executed			in the caller's own execution context
#
# @output storage	{ns}:work ahead : the point one block down the caller's line of sight
#
# @description		`execute summon` grants the execution position but not the execution rotation, so the
#					rotation is recovered by facing a point one block ahead. That point is read off the
#					marker standing on it instead of being selected back later: a chunk the caller only
#					just teleported into still holds entities no selector can see.
#

execute positioned ^ ^ ^1 summon marker run function {ns}:v{version}/travel/waypoints/read_ahead
""")

	write_versioned_function("travel/waypoints/read_ahead", f"""
#> read_ahead
#
# @executed			as a throwaway marker standing one block down the caller's line of sight
#

data modify storage {ns}:work ahead set value {{x:0.0d,y:0.0d,z:0.0d}}
data modify storage {ns}:work ahead.x set from entity @s Pos[0]
data modify storage {ns}:work ahead.y set from entity @s Pos[1]
data modify storage {ns}:work ahead.z set from entity @s Pos[2]
kill @s
""")

	write_versioned_function("travel/waypoints/face_ahead", """
#> face_ahead
#
# @executed			as a marker standing on the caller's position
#
# @input macro		x, y, z : double - the point look_ahead read one block down the line of sight
#

$tp @s ~ ~ ~ facing $(x) $(y) $(z)
""")

	write_versioned_function("travel/waypoints/read_here", f"""
#> read_here
#
# @executed			as a throwaway marker freshly summoned on the caller's position
#
# @input storage	{ns}:work ahead : the point to face, from look_ahead
# @output storage	{ns}:work wp : the caller's own position and rotation, as a waypoint
#

function {ns}:v{version}/travel/waypoints/face_ahead with storage {ns}:work ahead
data modify storage {ns}:work wp set value {{pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}}
data modify storage {ns}:work wp.pos set from entity @s Pos
data modify storage {ns}:work wp.rot set from entity @s Rotation
kill @s
""")

	write_versioned_function("travel/waypoints/resolve_at", f"""
#> resolve_at
#
# @input macro		i : int - index of the waypoint whose `at` string needs resolving
#
# @description		Run the caller's coordinate string through `execute positioned` from a marker standing
#					where the caller was, so `~`, `^` and plain numbers all mean exactly what they would
#					in the original command. Waypoints written that way are rare, so the marker is paid
#					for here rather than once per launch.
#

$data modify storage {ns}:work one_at.at set from storage {ns}:work args.waypoints[$(i)].at
function {ns}:v{version}/travel/waypoints/look_ahead
execute summon marker run function {ns}:v{version}/travel/waypoints/resolve_at_anchor
$data modify storage {ns}:work args.waypoints[$(i)].pos set from storage {ns}:work resolved
""")

	write_versioned_function("travel/waypoints/resolve_at_anchor", f"""
#> resolve_at_anchor
#
# @executed			as a throwaway marker freshly summoned on the caller's position
#

function {ns}:v{version}/travel/waypoints/face_ahead with storage {ns}:work ahead
execute at @s run function {ns}:v{version}/travel/waypoints/resolve_at_run with storage {ns}:work one_at
kill @s
""")

	write_versioned_function("travel/waypoints/resolve_at_run", f"""
#> resolve_at_run
#
# @executed			at the marker, so the string resolves against the caller's position and rotation
# @input macro		at : string - a coordinate triple, ex: "~10 ~5 ~3" or "^ ^ ^12"
#

$execute positioned $(at) summon marker run function {ns}:v{version}/travel/waypoints/capture_resolved
""")

	write_versioned_function("travel/waypoints/capture_resolved", f"""
data modify storage {ns}:work resolved set from entity @s Pos
kill @s
""")


def write_waypoints(ns: str, version: str) -> None:
	""" Build the waypoint list from the caller's arguments, then normalize it into a uniform shape. """
	write_capture(ns, version)

	write_versioned_function("travel/waypoints/target_here", f"""
#> target_here
#
# @executed			as the player, in the caller's execution context
#
# @description		Close the waypoint list on wherever the command was pointing, at eye height.
#					This is what lets a command block aim a cinematic with `~` and `^` coordinates.
#

function {ns}:v{version}/travel/waypoints/look_ahead
execute summon marker run function {ns}:v{version}/travel/waypoints/read_here
function {ns}:v{version}/travel/waypoints/raise_eyes
function {ns}:v{version}/travel/waypoints/override_rotation
data modify storage {ns}:work args.waypoints append from storage {ns}:work wp
""")

	write_versioned_function("travel/waypoints/start_here", f"""
#> start_here
#
# @executed			as the player
#
# @description		Open the waypoint list on the player's own eyes.
#

data modify storage {ns}:work args.waypoints set value []
data modify storage {ns}:work wp set value {{pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}}
data modify storage {ns}:work wp.pos set from entity @s Pos
data modify storage {ns}:work wp.rot set from entity @s Rotation
function {ns}:v{version}/travel/waypoints/raise_eyes
data modify storage {ns}:work args.waypoints append from storage {ns}:work wp
""")

	write_versioned_function("travel/waypoints/prepend_here", f"""
#> prepend_here
#
# @executed			as the player
#
# @description		Complete a single-waypoint path by starting it where the player currently stands.
#

data modify storage {ns}:work wp set value {{pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}}
data modify storage {ns}:work wp.pos set from entity @s Pos
data modify storage {ns}:work wp.rot set from entity @s Rotation
function {ns}:v{version}/travel/waypoints/raise_eyes
data modify storage {ns}:work args.waypoints prepend from storage {ns}:work wp
""")

	write_versioned_function("travel/waypoints/raise_eyes", f"""
#> raise_eyes
#
# @description		Lift the pending waypoint from the feet to the eyes, so the camera never starts inside the ground.
#

execute store result score #n {ns}.data run data get storage {ns}:work wp.pos[1] 1000
scoreboard players add #n {ns}.data 1600
execute store result storage {ns}:work wp.pos[1] double 0.001 run scoreboard players get #n {ns}.data
""")

	write_versioned_function("travel/waypoints/target_from_coords", f"""
#> target_from_coords
#
# @executed			as the player
#
# @description		Close the waypoint list on the coordinates the caller asked for, at eye height.
#

data modify storage {ns}:work wp set value {{pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}}
execute store result score #n {ns}.data run data get storage {ns}:work args.x 1000
execute store result storage {ns}:work wp.pos[0] double 0.001 run scoreboard players get #n {ns}.data
execute store result score #n {ns}.data run data get storage {ns}:work args.y 1000
scoreboard players add #n {ns}.data 1600
execute store result storage {ns}:work wp.pos[1] double 0.001 run scoreboard players get #n {ns}.data
execute store result score #n {ns}.data run data get storage {ns}:work args.z 1000
execute store result storage {ns}:work wp.pos[2] double 0.001 run scoreboard players get #n {ns}.data

# The player keeps looking the same way unless the caller said otherwise
data modify storage {ns}:work wp.rot set from entity @s Rotation
function {ns}:v{version}/travel/waypoints/override_rotation
data modify storage {ns}:work args.waypoints append from storage {ns}:work wp
""")

	write_versioned_function("travel/waypoints/target_from_entity", f"""
#> target_from_entity
#
# @description		Close the waypoint list on another entity's position and rotation, at eye height.
#

data modify storage {ns}:work wp set value {{pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}}
function {ns}:v{version}/travel/waypoints/read_target with storage {ns}:work args
function {ns}:v{version}/travel/waypoints/raise_eyes
function {ns}:v{version}/travel/waypoints/override_rotation
data modify storage {ns}:work args.waypoints append from storage {ns}:work wp
""")

	write_versioned_function("travel/waypoints/read_target", f"""
#> read_target
#
# @input macro		target : string - the selector to copy the position and rotation from
#

$data modify storage {ns}:work wp.pos set from entity $(target) Pos
$data modify storage {ns}:work wp.rot set from entity $(target) Rotation
""")

	write_versioned_function("travel/waypoints/override_rotation", f"""
#> override_rotation
#
# @description		Apply the caller's yaw and pitch on top of whatever rotation the target had.
#

execute if data storage {ns}:work args.yaw store result score #n {ns}.data run data get storage {ns}:work args.yaw 1000
execute if data storage {ns}:work args.yaw store result storage {ns}:work wp.rot[0] float 0.001 run scoreboard players get #n {ns}.data
execute if data storage {ns}:work args.pitch store result score #n {ns}.data run data get storage {ns}:work args.pitch 1000
execute if data storage {ns}:work args.pitch store result storage {ns}:work wp.rot[1] float 0.001 run scoreboard players get #n {ns}.data
""")

	write_versioned_function("travel/waypoints/normalize", f"""
#> normalize
#
# @output score		#segments, #share {ns}.data
#
# @description		Give every waypoint a rotation and a duration, and unwrap the yaws so the camera
#					always turns the short way round instead of spinning most of a circle.
#

## One segment per gap between waypoints, each getting an equal share of the total by default
execute store result score #count {ns}.data run data get storage {ns}:work args.waypoints
scoreboard players operation #segments {ns}.data = #count {ns}.data
scoreboard players remove #segments {ns}.data 1
execute if score #segments {ns}.data matches ..0 run scoreboard players set #segments {ns}.data 1
scoreboard players operation #share {ns}.data = #duration {ns}.data
scoreboard players operation #share {ns}.data /= #segments {ns}.data
execute if score #share {ns}.data matches ..0 run scoreboard players set #share {ns}.data 1

## Seed the running rotation, so a waypoint without one simply keeps the previous heading
data modify storage {ns}:work last_rot set value [0.0f,0.0f]
execute unless score #mode {ns}.data matches 2 run data modify storage {ns}:work last_rot set from entity @s Rotation
execute if data storage {ns}:work args.waypoints[0].rot run data modify storage {ns}:work last_rot set from storage {ns}:work args.waypoints[0].rot
execute store result score #last_yaw {ns}.data run data get storage {ns}:work last_rot[0] 1000

scoreboard players set #w {ns}.data 0
function {ns}:v{version}/travel/waypoints/normalize_loop
""")

	write_versioned_function("travel/waypoints/normalize_loop", f"""
execute if score #w {ns}.data < #count {ns}.data run function {ns}:v{version}/travel/waypoints/normalize_one
""")

	write_versioned_function("travel/waypoints/normalize_one", f"""
execute store result storage {ns}:work sel.i int 1 run scoreboard players get #w {ns}.data
function {ns}:v{version}/travel/waypoints/fill with storage {ns}:work sel
scoreboard players add #w {ns}.data 1
function {ns}:v{version}/travel/waypoints/normalize_loop
""")

	write_versioned_function("travel/waypoints/fill", f"""
#> fill
#
# @input macro		i : int - index of the waypoint to complete
#
# @description		Inherit the missing rotation and duration, then unwrap this waypoint's yaw.
#

$execute if data storage {ns}:work args.waypoints[$(i)].args run function {ns}:v{version}/travel/waypoints/expand with storage {ns}:work sel
$execute if data storage {ns}:work args.waypoints[$(i)].at run function {ns}:v{version}/travel/waypoints/resolve_at with storage {ns}:work sel
$execute unless data storage {ns}:work args.waypoints[$(i)].rot run data modify storage {ns}:work args.waypoints[$(i)].rot set from storage {ns}:work last_rot
$execute unless data storage {ns}:work args.waypoints[$(i)].duration store result storage {ns}:work args.waypoints[$(i)].duration int 1 run scoreboard players get #share {ns}.data

## A waypoint duration drives its own segment's frame loop, so it gets the same bounds as the travel total
$execute store result score #wp_duration {ns}.data run data get storage {ns}:work args.waypoints[$(i)].duration
execute if score #wp_duration {ns}.data matches ..0 run scoreboard players set #wp_duration {ns}.data 1
execute if score #wp_duration {ns}.data matches {MAX_DURATION + 1}.. run scoreboard players set #wp_duration {ns}.data {MAX_DURATION}
$execute store result storage {ns}:work args.waypoints[$(i)].duration int 1 run scoreboard players get #wp_duration {ns}.data

## Keep the yaw within half a turn of the previous one (a 350 degree spin becomes a 10 degree one)
$execute store result score #yaw {ns}.data run data get storage {ns}:work args.waypoints[$(i)].rot[0] 1000
scoreboard players operation #diff {ns}.data = #yaw {ns}.data
scoreboard players operation #diff {ns}.data -= #last_yaw {ns}.data
execute if score #diff {ns}.data matches 180000.. run scoreboard players remove #yaw {ns}.data 360000
execute if score #diff {ns}.data matches ..-180000 run scoreboard players add #yaw {ns}.data 360000
$execute store result storage {ns}:work args.waypoints[$(i)].rot[0] float 0.001 run scoreboard players get #yaw {ns}.data
scoreboard players operation #last_yaw {ns}.data = #yaw {ns}.data
$data modify storage {ns}:work last_rot set from storage {ns}:work args.waypoints[$(i)].rot
""")

	write_versioned_function("travel/waypoints/expand", f"""
#> expand
#
# @input macro		i : int - index of the waypoint to expand
#
# @description		Unpack the flat `args` form of a waypoint into `pos`, `rot` and `duration`.
#					Everything goes through a score, so writing plain integers works as well as decimals.
#

$data modify storage {ns}:work args.waypoints[$(i)].pos set value [0.0d,0.0d,0.0d]
$execute store result score #n {ns}.data run data get storage {ns}:work args.waypoints[$(i)].args[0] 1000
$execute store result storage {ns}:work args.waypoints[$(i)].pos[0] double 0.001 run scoreboard players get #n {ns}.data
$execute store result score #n {ns}.data run data get storage {ns}:work args.waypoints[$(i)].args[1] 1000
$execute store result storage {ns}:work args.waypoints[$(i)].pos[1] double 0.001 run scoreboard players get #n {ns}.data
$execute store result score #n {ns}.data run data get storage {ns}:work args.waypoints[$(i)].args[2] 1000
$execute store result storage {ns}:work args.waypoints[$(i)].pos[2] double 0.001 run scoreboard players get #n {ns}.data

# The rotation and the duration are optional tail elements, so a three element form still inherits them
$execute if data storage {ns}:work args.waypoints[$(i)].args[4] run function {ns}:v{version}/travel/waypoints/expand_rot with storage {ns}:work sel
$execute if data storage {ns}:work args.waypoints[$(i)].args[5] store result storage {ns}:work args.waypoints[$(i)].duration int 1 run data get storage {ns}:work args.waypoints[$(i)].args[5]
""")

	write_versioned_function("travel/waypoints/expand_rot", f"""
#> expand_rot
#
# @input macro		i : int - index of the waypoint to expand
#

$data modify storage {ns}:work args.waypoints[$(i)].rot set value [0.0f,0.0f]
$execute store result score #n {ns}.data run data get storage {ns}:work args.waypoints[$(i)].args[3] 1000
$execute store result storage {ns}:work args.waypoints[$(i)].rot[0] float 0.001 run scoreboard players get #n {ns}.data
$execute store result score #n {ns}.data run data get storage {ns}:work args.waypoints[$(i)].args[4] 1000
$execute store result storage {ns}:work args.waypoints[$(i)].rot[1] float 0.001 run scoreboard players get #n {ns}.data
""")

