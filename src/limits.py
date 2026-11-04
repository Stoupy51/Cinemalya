""" Hard bounds on everything the pack loops over.

Every loop in the pack is a recursive function whose bound comes from the caller's arguments,
so an absurd argument is the difference between a cinematic and a frozen server.
Each limit below is enforced where the loop is set up, never inside the loop itself.
"""
# Constants
MAX_WAYPOINTS: int = 128
""" Waypoints one path may hold. A longer list is refused, since the count also drives the control point and segment loops. """

MAX_TAGS: int = 32
""" Extra tags copied onto the cinematic entity. Anything past this is dropped rather than looped over. """

MAX_DURATION: int = 36000
""" Ticks a travel, or any one of its segments, may last. Thirty minutes, and small enough that the totals stay inside an int. """

MAX_SMOOTHING: int = 100
""" Ticks between two frames. Higher would only mean a camera that never moves. """

MAX_FRAMES: int = 600
""" Frames the whole travel may emit. Reaching the cap raises the smoothing instead of cutting the path short. """

LAUNCH_BUDGET: int = 60000
""" Commands a launch may spend building its path, under the `max_command_sequence_length` default of 65536.
Past that limit Minecraft drops the rest of the launch silently, so no camera ever appears.
"""

SAMPLE_COST: int = 165
""" Commands one sample costs: Bookshelf's position and rotation samplers, the arc length, the walk over it. """

FRAME_COST: int = 48
""" Commands one frame costs to time, ease and interpolate. """

WAYPOINT_COST: int = 200
""" Commands one waypoint costs before sampling, plus Bookshelf's setup of its segment. """

MIN_SAMPLING_STEP: int = 1000
""" Sampling step handed to Bookshelf, in millionths. It reads the step back as `step * 1000` truncated to an int,
so anything below a thousandth arrives as a step of zero and its sampler recurses until the server dies.
"""

