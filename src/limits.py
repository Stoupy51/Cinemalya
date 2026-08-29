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

MAX_FRAMES: int = 1200
""" Frames the whole travel may emit. Reaching the cap raises the smoothing instead of cutting the path short. """

MIN_SAMPLING_STEP: int = 1000
""" Sampling step handed to Bookshelf, in millionths. It reads the step back as `step * 1000` truncated to an int,
so anything below a thousandth arrives as a step of zero and its sampler recurses until the server dies.
"""

