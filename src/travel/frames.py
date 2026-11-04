# Imports
from stewbeet import write_versioned_function

from ..limits import MAX_FRAMES


def write_frames(ns: str, version: str) -> None:
	""" Pick, once and for all, the point every playback step will land on. """
	write_versioned_function("travel/frames/main", f"""
#> main
#
# @input storage	{ns}:work samples, {ns}:work rot_samples, {ns}:work lengths, {ns}:work bounds
# @input score		#shared_length, #shared_count {ns}.data
# @output storage	{ns}:work frames : one entry per playback step
#
# @description		Walk the travel one frame at a time. Each frame works out how far along the path it
#					should be, then lands between the two samples around that distance. Time is counted
#					in hundredths of a frame, so a segment may end between two frames. Doing it here
#					means playback never computes anything: it just pops.
#

data modify storage {ns}:work frames set value {{points:[],rotations:[]}}
scoreboard players operation #last_seg {ns}.data = #segments {ns}.data
scoreboard players remove #last_seg {ns}.data 1

## The segments without a duration of their own share theirs in proportion to their length,
## so the camera keeps one speed through every waypoint between them
scoreboard players operation #shared_time {ns}.data = #duration {ns}.data
scoreboard players operation #shared_time {ns}.data *= #shared_count {ns}.data
scoreboard players operation #shared_time {ns}.data /= #segments {ns}.data
scoreboard players operation #shared_time {ns}.data /= #smoothing {ns}.data
execute if score #shared_time {ns}.data matches ..0 run scoreboard players set #shared_time {ns}.data 1
scoreboard players operation #shared_time {ns}.data *= #100 {ns}.data
execute if score #shared_length {ns}.data matches ..0 run scoreboard players set #shared_length {ns}.data 1
scoreboard players operation #pace {ns}.data = #shared_time {ns}.data
scoreboard players operation #pace {ns}.data *= #10000 {ns}.data
scoreboard players operation #pace {ns}.data /= #shared_length {ns}.data
scoreboard players set #shared_done {ns}.data 0
scoreboard players set #shared_spent {ns}.data 0

## Start before the first segment, on the first sample interval
scoreboard players set #seg {ns}.data -1
scoreboard players set #seg_end {ns}.data 0
scoreboard players set #time {ns}.data 0
execute store result score #l1 {ns}.data run data get storage {ns}:work bounds[0]
execute store result score #from_length {ns}.data run data get storage {ns}:work lengths[0]
execute store result score #to_length {ns}.data run data get storage {ns}:work lengths[1]
function {ns}:v{version}/travel/frames/load_interval

# Frames left to spend. Raising the smoothing keeps a normal travel well clear of it,
# so this only ever bites on per waypoint durations, which no earlier total can bound.
scoreboard players set #budget {ns}.data {MAX_FRAMES}
function {ns}:v{version}/travel/frames/frame
""")

	write_versioned_function("travel/frames/frame", f"""
#> frame
#
# @description		Emit the frame one frame later than the previous one, then the next.
#

scoreboard players add #time {ns}.data 100
execute if score #time {ns}.data > #seg_end {ns}.data run function {ns}:v{version}/travel/frames/next_segment
execute if score #seg {ns}.data >= #segments {ns}.data run return 0

## Progress through the segment, in ten thousandths, bent by the easing curve
scoreboard players operation #p {ns}.data = #time {ns}.data
scoreboard players operation #p {ns}.data -= #seg_start {ns}.data
scoreboard players operation #p {ns}.data *= #10000 {ns}.data
scoreboard players operation #p {ns}.data /= #seg_span {ns}.data
execute unless score #ease {ns}.data matches 0 run function {ns}:v{version}/travel/frames/ease

## Distance along the path, then the sample interval holding it
scoreboard players operation #s {ns}.data = #seg_length {ns}.data
scoreboard players operation #s {ns}.data *= #p {ns}.data
scoreboard players operation #s {ns}.data /= #10000 {ns}.data
scoreboard players operation #s {ns}.data += #l0 {ns}.data
execute if score #to_length {ns}.data < #s {ns}.data if data storage {ns}:work lengths[2] run function {ns}:v{version}/travel/frames/walk
function {ns}:v{version}/travel/frames/land

scoreboard players remove #budget {ns}.data 1
execute if score #budget {ns}.data matches 1.. run function {ns}:v{version}/travel/frames/frame
""")

	write_versioned_function("travel/frames/next_segment", f"""
#> next_segment
#
# @description		Move on to the segment #time falls in, skipping any too short to hold a frame.
#

scoreboard players add #seg {ns}.data 1
execute if score #seg {ns}.data >= #segments {ns}.data run return 0
scoreboard players operation #seg_start {ns}.data = #seg_end {ns}.data
scoreboard players operation #l0 {ns}.data = #l1 {ns}.data
data remove storage {ns}:work bounds[0]
execute store result score #l1 {ns}.data run data get storage {ns}:work bounds[0]
scoreboard players operation #seg_length {ns}.data = #l1 {ns}.data
scoreboard players operation #seg_length {ns}.data -= #l0 {ns}.data

scoreboard players operation #n {ns}.data = #seg {ns}.data
scoreboard players add #n {ns}.data 1
execute store result storage {ns}:work sel.i int 1 run scoreboard players get #n {ns}.data
function {ns}:v{version}/travel/frames/read_duration with storage {ns}:work sel
scoreboard players operation #seg_end {ns}.data = #seg_start {ns}.data
scoreboard players operation #seg_end {ns}.data += #seg_span {ns}.data
function {ns}:v{version}/travel/frames/segment_ease

execute if score #time {ns}.data > #seg_end {ns}.data run function {ns}:v{version}/travel/frames/next_segment
""")

	write_versioned_function("travel/frames/read_duration", f"""
#> read_duration
#
# @input macro		i : int - the waypoint this segment arrives at
# @output score		#seg_span {ns}.data : how long the segment lasts, in hundredths of a frame
#

$execute store result score #seg_span {ns}.data run data get storage {ns}:work args.waypoints[$(i)].duration
execute if score #seg_span {ns}.data matches 0 run return run function {ns}:v{version}/travel/frames/shared_span
scoreboard players operation #seg_span {ns}.data /= #smoothing {ns}.data
execute if score #seg_span {ns}.data matches ..0 run scoreboard players set #seg_span {ns}.data 1
scoreboard players operation #seg_span {ns}.data *= #100 {ns}.data
""")

	write_versioned_function("travel/frames/shared_span", f"""
#> shared_span
#
# @description		A segment without a duration ends where its length takes it at the shared pace.
#					The last of them ends exactly on the shared time, so rounding never stretches the travel.
#

scoreboard players operation #shared_done {ns}.data += #seg_length {ns}.data
scoreboard players operation #seg_span {ns}.data = #shared_done {ns}.data
scoreboard players operation #seg_span {ns}.data *= #pace {ns}.data
scoreboard players operation #seg_span {ns}.data /= #10000 {ns}.data
execute if score #shared_done {ns}.data >= #shared_length {ns}.data run scoreboard players operation #seg_span {ns}.data = #shared_time {ns}.data
scoreboard players operation #seg_span {ns}.data -= #shared_spent {ns}.data
scoreboard players operation #shared_spent {ns}.data += #seg_span {ns}.data
""")

	write_versioned_function("travel/frames/segment_ease", f"""
#> segment_ease
#
# @input score		#ease_path {ns}.data : the easing asked for by the whole path
# @output score		#ease {ns}.data : the easing this one segment runs
#
# @description		Easing bends progress from 0 to 1, so running the path's curve inside every segment
#					would bring the camera to a near stop on each intermediate waypoint. The path's
#					curve therefore lands on its ends only: it accelerates away from the first
#					waypoint, cruises through the middle ones, and settles onto the last.
#					A waypoint carrying its own `ease` overrides that for the segment arriving at it.
#

## Middle segments cruise, the ends accelerate away from rest and settle back onto it
scoreboard players set #ease {ns}.data 0
execute if score #seg {ns}.data matches 0 if score #ease_path {ns}.data matches 1 run scoreboard players set #ease {ns}.data 4
execute if score #seg {ns}.data matches 0 if score #ease_path {ns}.data matches 3 run scoreboard players set #ease {ns}.data 4
execute if score #seg {ns}.data = #last_seg {ns}.data if score #ease_path {ns}.data matches 2 run scoreboard players set #ease {ns}.data 5
execute if score #seg {ns}.data = #last_seg {ns}.data if score #ease_path {ns}.data matches 3 run scoreboard players set #ease {ns}.data 5

## A single segment is both ends at once, so it runs the path's curve whole
execute if score #segments {ns}.data matches 1 run scoreboard players operation #ease {ns}.data = #ease_path {ns}.data

## The waypoint this segment arrives at has the final say
function {ns}:v{version}/travel/frames/read_ease with storage {ns}:work sel
""")

	write_versioned_function("travel/frames/read_ease", f"""
#> read_ease
#
# @input macro		i : int - the waypoint this segment arrives at
#

data remove storage {ns}:work sel.ease_linear
$data modify storage {ns}:work sel.ease_linear set from storage {ns}:work args.waypoints[$(i)].ease
execute if data storage {ns}:work sel{{ease_linear:"linear"}} run scoreboard players set #ease {ns}.data 0
execute if data storage {ns}:work sel{{ease_linear:"ease_in"}} run scoreboard players set #ease {ns}.data 1
execute if data storage {ns}:work sel{{ease_linear:"ease_out"}} run scoreboard players set #ease {ns}.data 2
execute if data storage {ns}:work sel{{ease_linear:"ease_in_out"}} run scoreboard players set #ease {ns}.data 3
""")

	write_versioned_function("travel/frames/walk", f"""
#> walk
#
# @description		Drop the samples behind the camera until the interval ahead holds the distance #s.
#

data remove storage {ns}:work samples[0]
data remove storage {ns}:work rot_samples[0]
data remove storage {ns}:work lengths[0]
scoreboard players operation #from_length {ns}.data = #to_length {ns}.data
execute store result score #to_length {ns}.data run data get storage {ns}:work lengths[1]
execute if score #to_length {ns}.data < #s {ns}.data if data storage {ns}:work lengths[2] run return run function {ns}:v{version}/travel/frames/walk
function {ns}:v{version}/travel/frames/load_interval
""")

	write_versioned_function("travel/frames/load_interval", f"""
#> load_interval
#
# @description		Read the interval between the first two samples left as a start and a step per axis,
#					in thousandths, so every frame landing in it costs no storage read.
#

execute store result score #from_x {ns}.data run data get storage {ns}:work samples[0][0] 1000
execute store result score #from_y {ns}.data run data get storage {ns}:work samples[0][1] 1000
execute store result score #from_z {ns}.data run data get storage {ns}:work samples[0][2] 1000
execute store result score #from_yaw {ns}.data run data get storage {ns}:work rot_samples[0][0] 1000
execute store result score #from_pitch {ns}.data run data get storage {ns}:work rot_samples[0][1] 1000
execute store result score #step_x {ns}.data run data get storage {ns}:work samples[1][0] 1000
execute store result score #step_y {ns}.data run data get storage {ns}:work samples[1][1] 1000
execute store result score #step_z {ns}.data run data get storage {ns}:work samples[1][2] 1000
execute store result score #step_yaw {ns}.data run data get storage {ns}:work rot_samples[1][0] 1000
execute store result score #step_pitch {ns}.data run data get storage {ns}:work rot_samples[1][1] 1000
scoreboard players operation #step_x {ns}.data -= #from_x {ns}.data
scoreboard players operation #step_y {ns}.data -= #from_y {ns}.data
scoreboard players operation #step_z {ns}.data -= #from_z {ns}.data
scoreboard players operation #step_yaw {ns}.data -= #from_yaw {ns}.data
scoreboard players operation #step_pitch {ns}.data -= #from_pitch {ns}.data
scoreboard players operation #interval {ns}.data = #to_length {ns}.data
scoreboard players operation #interval {ns}.data -= #from_length {ns}.data
""")

	write_versioned_function("travel/frames/land", f"""
#> land
#
# @description		Append the point lying at distance #s, interpolated between the interval's two samples.
#					Snapping to the nearest sample instead would make every step one or two samples long.
#

scoreboard players operation #fr {ns}.data = #s {ns}.data
scoreboard players operation #fr {ns}.data -= #from_length {ns}.data
scoreboard players operation #fr {ns}.data *= #1000 {ns}.data
scoreboard players operation #fr {ns}.data /= #interval {ns}.data

data modify storage {ns}:work frames.points append value [0.0d,0.0d,0.0d]
scoreboard players operation #v {ns}.data = #step_x {ns}.data
scoreboard players operation #v {ns}.data *= #fr {ns}.data
scoreboard players operation #v {ns}.data /= #1000 {ns}.data
execute store result storage {ns}:work frames.points[-1][0] double 0.001 run scoreboard players operation #v {ns}.data += #from_x {ns}.data
scoreboard players operation #v {ns}.data = #step_y {ns}.data
scoreboard players operation #v {ns}.data *= #fr {ns}.data
scoreboard players operation #v {ns}.data /= #1000 {ns}.data
execute store result storage {ns}:work frames.points[-1][1] double 0.001 run scoreboard players operation #v {ns}.data += #from_y {ns}.data
scoreboard players operation #v {ns}.data = #step_z {ns}.data
scoreboard players operation #v {ns}.data *= #fr {ns}.data
scoreboard players operation #v {ns}.data /= #1000 {ns}.data
execute store result storage {ns}:work frames.points[-1][2] double 0.001 run scoreboard players operation #v {ns}.data += #from_z {ns}.data

data modify storage {ns}:work frames.rotations append value [0.0f,0.0f]
scoreboard players operation #v {ns}.data = #step_yaw {ns}.data
scoreboard players operation #v {ns}.data *= #fr {ns}.data
scoreboard players operation #v {ns}.data /= #1000 {ns}.data
execute store result storage {ns}:work frames.rotations[-1][0] float 0.001 run scoreboard players operation #v {ns}.data += #from_yaw {ns}.data
scoreboard players operation #v {ns}.data = #step_pitch {ns}.data
scoreboard players operation #v {ns}.data *= #fr {ns}.data
scoreboard players operation #v {ns}.data /= #1000 {ns}.data
execute store result storage {ns}:work frames.rotations[-1][1] float 0.001 run scoreboard players operation #v {ns}.data += #from_pitch {ns}.data
""")

	write_versioned_function("travel/frames/ease", f"""
#> ease
#
# @input score		#p {ns}.data : linear progress, 0 to 10000
# @output score		#p {ns}.data : eased progress, 0 to 10000
#
# @description		Bend the progress so the camera accelerates, decelerates, or does both.
#

execute if score #ease {ns}.data matches 1 run function {ns}:v{version}/travel/frames/ease_in
execute if score #ease {ns}.data matches 2 run function {ns}:v{version}/travel/frames/ease_out
execute if score #ease {ns}.data matches 3 run function {ns}:v{version}/travel/frames/ease_in_out
execute if score #ease {ns}.data matches 4 run function {ns}:v{version}/travel/frames/ease_in_to_cruise
execute if score #ease {ns}.data matches 5 run function {ns}:v{version}/travel/frames/ease_out_of_cruise
""")

	write_versioned_function("travel/frames/ease_in_to_cruise", f"""
#> ease_in_to_cruise
#
# @description		2t^2 - t^3: starts at rest like ease_in, but arrives at exactly the speed a linear
#					segment travels at, so the waypoint it hands over on shows no change of pace.
#

scoreboard players operation #q {ns}.data = #p {ns}.data
scoreboard players operation #q {ns}.data *= #p {ns}.data
scoreboard players operation #q {ns}.data /= #10000 {ns}.data
scoreboard players operation #r {ns}.data = #q {ns}.data
scoreboard players operation #r {ns}.data *= #p {ns}.data
scoreboard players operation #r {ns}.data /= #10000 {ns}.data
scoreboard players operation #p {ns}.data = #q {ns}.data
scoreboard players operation #p {ns}.data *= #2 {ns}.data
scoreboard players operation #p {ns}.data -= #r {ns}.data
""")

	write_versioned_function("travel/frames/ease_out_of_cruise", f"""
#> ease_out_of_cruise
#
# @description		The mirror of ease_in_to_cruise: leaves its waypoint at cruising speed and settles
#					to rest, so the handover into it is seamless too.
#

scoreboard players operation #u {ns}.data = #10000 {ns}.data
scoreboard players operation #u {ns}.data -= #p {ns}.data
scoreboard players operation #q {ns}.data = #u {ns}.data
scoreboard players operation #q {ns}.data *= #u {ns}.data
scoreboard players operation #q {ns}.data /= #10000 {ns}.data
scoreboard players operation #r {ns}.data = #q {ns}.data
scoreboard players operation #r {ns}.data *= #u {ns}.data
scoreboard players operation #r {ns}.data /= #10000 {ns}.data
scoreboard players operation #q {ns}.data *= #2 {ns}.data
scoreboard players operation #q {ns}.data -= #r {ns}.data
scoreboard players operation #p {ns}.data = #10000 {ns}.data
scoreboard players operation #p {ns}.data -= #q {ns}.data
""")

	write_versioned_function("travel/frames/ease_in", f"""
# p squared: slow to start, fastest on arrival
scoreboard players operation #p {ns}.data *= #p {ns}.data
scoreboard players operation #p {ns}.data /= #10000 {ns}.data
""")

	write_versioned_function("travel/frames/ease_out", f"""
# One minus the square of the remainder: fastest at launch, settling onto the target
scoreboard players operation #q {ns}.data = #10000 {ns}.data
scoreboard players operation #q {ns}.data -= #p {ns}.data
scoreboard players operation #q {ns}.data *= #q {ns}.data
scoreboard players operation #q {ns}.data /= #10000 {ns}.data
scoreboard players operation #p {ns}.data = #10000 {ns}.data
scoreboard players operation #p {ns}.data -= #q {ns}.data
""")

	write_versioned_function("travel/frames/ease_in_out", f"""
# Smoothstep, staged through two divisions so the intermediate product stays inside an int
scoreboard players operation #q {ns}.data = #p {ns}.data
scoreboard players operation #q {ns}.data *= #p {ns}.data
scoreboard players operation #q {ns}.data /= #10000 {ns}.data
scoreboard players operation #p {ns}.data *= #-2 {ns}.data
scoreboard players operation #p {ns}.data += #30000 {ns}.data
scoreboard players operation #p {ns}.data *= #q {ns}.data
scoreboard players operation #p {ns}.data /= #10000 {ns}.data
""")

