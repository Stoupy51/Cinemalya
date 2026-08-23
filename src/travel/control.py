# Imports
from stewbeet import write_versioned_function


def write_control(ns: str, version: str) -> None:
	""" Turn the waypoints into the control points the spline sampler expects. """
	write_versioned_function("travel/control/main", f"""
#> main
#
# @output storage	{ns}:work control, {ns}:work rot_control
#
# @description		Two waypoints get a bezier bending through an arc point, more get a catmull-rom
#					passing through every one of them. The caller can force either with `spline`.
#

data modify storage {ns}:work control set value {{points:[],step:1.0d}}
data modify storage {ns}:work rot_control set value {{points:[],step:1.0d}}

## Pick the curve
scoreboard players set #curve {ns}.data 0
execute if score #segments {ns}.data matches 2.. run scoreboard players set #curve {ns}.data 1
execute if data storage {ns}:work args{{spline:"bezier"}} run scoreboard players set #curve {ns}.data 0
execute if data storage {ns}:work args{{spline:"catmull_rom"}} run scoreboard players set #curve {ns}.data 1

execute if score #curve {ns}.data matches 0 run function {ns}:v{version}/travel/control/arc
execute if score #curve {ns}.data matches 1 run function {ns}:v{version}/travel/control/through
""")

	write_versioned_function("travel/control/arc", f"""
#> arc
#
# @description		A four point bezier from the first waypoint to the last, bending through a raised
#					midpoint. The end is repeated so the curve settles onto it instead of overshooting.
#

function {ns}:v{version}/travel/control/mid_point
data modify storage {ns}:work control.points append from storage {ns}:work args.waypoints[0].pos
data modify storage {ns}:work control.points append from storage {ns}:work mid
data modify storage {ns}:work control.points append from storage {ns}:work args.waypoints[-1].pos
data modify storage {ns}:work control.points append from storage {ns}:work args.waypoints[-1].pos

# The rotation gets no arc: it just eases from the start heading to the target one
data modify storage {ns}:work rot_control.points append from storage {ns}:work args.waypoints[0].rot
data modify storage {ns}:work rot_control.points append from storage {ns}:work args.waypoints[0].rot
data modify storage {ns}:work rot_control.points append from storage {ns}:work args.waypoints[-1].rot
data modify storage {ns}:work rot_control.points append from storage {ns}:work args.waypoints[-1].rot
""")

	write_versioned_function("travel/control/mid_point", f"""
#> mid_point
#
# @output storage	{ns}:work mid : the raised, optionally sidestepped midpoint of the travel
#
# @description		Place the arc's control point halfway along the travel, above the higher of the
#					two ends, and pushed sideways by a fraction of half the distance covered.
#

## Both ends, in thousandths of a block
execute store result score #sx {ns}.data run data get storage {ns}:work args.waypoints[0].pos[0] 1000
execute store result score #sy {ns}.data run data get storage {ns}:work args.waypoints[0].pos[1] 1000
execute store result score #sz {ns}.data run data get storage {ns}:work args.waypoints[0].pos[2] 1000
execute store result score #tx {ns}.data run data get storage {ns}:work args.waypoints[-1].pos[0] 1000
execute store result score #ty {ns}.data run data get storage {ns}:work args.waypoints[-1].pos[1] 1000
execute store result score #tz {ns}.data run data get storage {ns}:work args.waypoints[-1].pos[2] 1000
scoreboard players operation #dx {ns}.data = #tx {ns}.data
scoreboard players operation #dx {ns}.data -= #sx {ns}.data
scoreboard players operation #dz {ns}.data = #tz {ns}.data
scoreboard players operation #dz {ns}.data -= #sz {ns}.data

## Halfway on the horizontal plane
data modify storage {ns}:work mid set value [0.0d,0.0d,0.0d]
scoreboard players operation #mx {ns}.data = #dx {ns}.data
scoreboard players operation #mx {ns}.data /= #2 {ns}.data
scoreboard players operation #mx {ns}.data += #sx {ns}.data
scoreboard players operation #mz {ns}.data = #dz {ns}.data
scoreboard players operation #mz {ns}.data /= #2 {ns}.data
scoreboard players operation #mz {ns}.data += #sz {ns}.data
execute store result storage {ns}:work mid[0] double 0.001 run scoreboard players get #mx {ns}.data
execute store result storage {ns}:work mid[2] double 0.001 run scoreboard players get #mz {ns}.data

## Above whichever end is higher
scoreboard players operation #my {ns}.data = #sy {ns}.data
execute if score #ty {ns}.data > #my {ns}.data run scoreboard players operation #my {ns}.data = #ty {ns}.data
execute store result score #n {ns}.data run data get storage {ns}:work args.arc_height 1000
scoreboard players operation #my {ns}.data += #n {ns}.data
execute store result storage {ns}:work mid[1] double 0.001 run scoreboard players get #my {ns}.data

## Sidestep, so the camera sweeps around the travel instead of flying straight down it
execute store result score #side {ns}.data run data get storage {ns}:work args.arc_side 1000
execute if score #side {ns}.data matches 0 run return 0
function {ns}:v{version}/travel/control/side_amount

# A travel straight up or down has no direction to sidestep from, and facing its own position would fail
execute if score #amount {ns}.data matches 0 run return 0
execute summon item_display run function {ns}:v{version}/travel/control/side_offset with storage {ns}:work forward
""")

	write_versioned_function("travel/control/side_amount", f"""
#> side_amount
#
# @output storage	{ns}:work forward : macro arguments for the sidestep
#
# @description		Half of the dominant horizontal offset, scaled by arc_side. The camera swings
#					towards the outside of the turn, so it keeps the destination in frame.
#

## Magnitude of the travel, on whichever horizontal axis dominates
scoreboard players operation #adx {ns}.data = #dx {ns}.data
execute if score #adx {ns}.data matches ..-1 run scoreboard players operation #adx {ns}.data *= #-1 {ns}.data
scoreboard players operation #adz {ns}.data = #dz {ns}.data
execute if score #adz {ns}.data matches ..-1 run scoreboard players operation #adz {ns}.data *= #-1 {ns}.data
scoreboard players operation #amount {ns}.data = #adx {ns}.data
execute if score #adz {ns}.data > #adx {ns}.data run scoreboard players operation #amount {ns}.data = #adz {ns}.data
scoreboard players operation #amount {ns}.data /= #2 {ns}.data
scoreboard players operation #amount {ns}.data *= #side {ns}.data

## Which way to swing, following the direction the camera is already turning
scoreboard players operation #yaw_diff {ns}.data = #last_yaw {ns}.data
execute store result score #n {ns}.data run data get storage {ns}:work args.waypoints[0].rot[0] 1000
scoreboard players operation #yaw_diff {ns}.data -= #n {ns}.data

data modify storage {ns}:work forward set value {{amount:0.0d,turn:90,tx:0.0d,ty:0.0d,tz:0.0d}}
execute store result storage {ns}:work forward.amount double 0.000001 run scoreboard players get #amount {ns}.data
execute if score #yaw_diff {ns}.data matches 0.. run data modify storage {ns}:work forward.turn set value -90
data modify storage {ns}:work forward.tx set from storage {ns}:work args.waypoints[-1].pos[0]
data modify storage {ns}:work forward.ty set from storage {ns}:work mid[1]
data modify storage {ns}:work forward.tz set from storage {ns}:work args.waypoints[-1].pos[2]
""")

	write_versioned_function("travel/control/side_offset", f"""
#> side_offset
#
# @executed			as a throwaway item_display
#
# @input macro		amount : double - how far to step sideways
# @input macro		turn : int - a quarter turn, left or right
# @input macro		tx, ty, tz : double - the point to face before turning
#
# @description		Stand on the midpoint, look at the destination on the level, turn a quarter
#					turn, then step. Local coordinates follow the execution rotation, so the
#					sidestep stays perpendicular to the travel wherever in the world it happens.
#

data modify entity @s Pos set from storage {ns}:work mid
$execute at @s facing $(tx) $(ty) $(tz) rotated ~$(turn) ~ run tp @s ^ ^ ^$(amount)
data modify storage {ns}:work mid set from entity @s Pos
kill @s
""")

	write_versioned_function("travel/control/through", f"""
#> through
#
# @description		Control points that make the curve pass through every waypoint: the sampler reads
#					four at a time, so the first and last are repeated to give the ends a tangent.
#

data modify storage {ns}:work control.points append from storage {ns}:work args.waypoints[0].pos
data modify storage {ns}:work rot_control.points append from storage {ns}:work args.waypoints[0].rot
scoreboard players set #w {ns}.data 0
function {ns}:v{version}/travel/control/collect_loop
data modify storage {ns}:work control.points append from storage {ns}:work args.waypoints[-1].pos
data modify storage {ns}:work rot_control.points append from storage {ns}:work args.waypoints[-1].rot
""")

	write_versioned_function("travel/control/collect_loop", f"""
execute if score #w {ns}.data < #count {ns}.data run function {ns}:v{version}/travel/control/collect_one
""")

	write_versioned_function("travel/control/collect_one", f"""
execute store result storage {ns}:work sel.i int 1 run scoreboard players get #w {ns}.data
function {ns}:v{version}/travel/control/collect with storage {ns}:work sel
scoreboard players add #w {ns}.data 1
function {ns}:v{version}/travel/control/collect_loop
""")

	write_versioned_function("travel/control/collect", f"""
$data modify storage {ns}:work control.points append from storage {ns}:work args.waypoints[$(i)].pos
$data modify storage {ns}:work rot_control.points append from storage {ns}:work args.waypoints[$(i)].rot
""")
