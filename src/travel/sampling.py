# Imports
from stewbeet import write_versioned_function


def write_sampling(ns: str, version: str) -> None:
	""" Run the control points through Bookshelf's spline sampler. """
	write_versioned_function("travel/sample/main", f"""
#> main
#
# @output storage	{ns}:work samples, {ns}:work rot_samples
# @output score		#frames, #last {ns}.data
#
# @description		Sample the curve into a dense polyline, comfortably finer than the frames that
#					will be picked out of it. Easing then only has to choose which sample to land on.
#

## How many frames the travel gets, and how densely to sample for them
scoreboard players operation #frames {ns}.data = #duration {ns}.data
scoreboard players operation #frames {ns}.data /= #smoothing {ns}.data
execute if score #frames {ns}.data matches ..0 run scoreboard players set #frames {ns}.data 1
scoreboard players operation #samples {ns}.data = #frames {ns}.data
scoreboard players operation #samples {ns}.data *= #4 {ns}.data
execute if score #samples {ns}.data matches ..32 run scoreboard players set #samples {ns}.data 32
execute if score #samples {ns}.data matches 400.. run scoreboard players set #samples {ns}.data 400

## Sampling step, in millionths, spread over the whole curve
scoreboard players operation #step {ns}.data = #segments {ns}.data
scoreboard players operation #step {ns}.data *= #1000000 {ns}.data
scoreboard players operation #step {ns}.data /= #samples {ns}.data
execute if score #step {ns}.data matches ..0 run scoreboard players set #step {ns}.data 1
execute store result storage {ns}:work control.step double 0.000001 run scoreboard players get #step {ns}.data
data modify storage {ns}:work rot_control.step set from storage {ns}:work control.step

execute if score #curve {ns}.data matches 0 run function {ns}:v{version}/travel/sample/bezier
execute if score #curve {ns}.data matches 1 run function {ns}:v{version}/travel/sample/catmull_rom

## Land exactly on the destination, whatever the sampler's own last step happened to be
data modify storage {ns}:work samples append from storage {ns}:work args.waypoints[-1].pos
data modify storage {ns}:work rot_samples append from storage {ns}:work args.waypoints[-1].rot

## Trust the sampler's output length rather than the requested step
execute store result score #last {ns}.data run data get storage {ns}:work samples
scoreboard players remove #last {ns}.data 1
execute if score #last {ns}.data matches ..0 run scoreboard players set #last {ns}.data 0
""")

	write_versioned_function("travel/sample/bezier", f"""
data modify storage bs:in spline.sample_bezier set from storage {ns}:work control
function #bs.spline:sample_bezier
data modify storage {ns}:work samples set from storage bs:out spline.sample_bezier

data modify storage bs:in spline.sample_bezier set from storage {ns}:work rot_control
function #bs.spline:sample_bezier
data modify storage {ns}:work rot_samples set from storage bs:out spline.sample_bezier
""")

	write_versioned_function("travel/sample/catmull_rom", f"""
data modify storage bs:in spline.sample_catmull_rom set from storage {ns}:work control
function #bs.spline:sample_catmull_rom
data modify storage {ns}:work samples set from storage bs:out spline.sample_catmull_rom

data modify storage bs:in spline.sample_catmull_rom set from storage {ns}:work rot_control
function #bs.spline:sample_catmull_rom
data modify storage {ns}:work rot_samples set from storage bs:out spline.sample_catmull_rom
""")
