# Imports
from stewbeet import Mem, write_versioned_function

# Constants
ENTRY_POINTS: dict[str, str] = {
	"launch":           "travel/from_coords",
	"launch_at_entity": "travel/from_entity",
	"launch_path":      "travel/from_waypoints",
	"stop":             "playback/stop",
	"intro":            "intro/start",
}
""" Public function tag name -> the versioned function it dispatches to once the version check passes. """

SIGNALS: tuple[str, ...] = ("on_launch", "on_finish")
""" Function tags the library fires so a datapack can react to a cinematic starting or ending. """


def main() -> None:
	""" Write the public function tags, each guarded so several library versions can coexist in one world. """
	ns: str = Mem.ctx.project_id
	version: str = Mem.ctx.project_version
	major, minor, patch = version.split(".")
	guard: str = f"if score #{ns}.major load.status matches {major} if score #{ns}.minor load.status matches {minor} if score #{ns}.patch load.status matches {patch}"

	for tag_name, target in ENTRY_POINTS.items():
		write_versioned_function(f"api/{tag_name}", f"""
#> {tag_name}
#
# @description		Version guard: only the newest {ns} loaded in the world runs the call.
#

$execute {guard} run function {ns}:v{version}/{target} {{with:$(with)}}
""", tags=[f"{ns}:v{major}/{tag_name}"])

	# Signals are pure extension points: the library owns the tag, datapacks own its members
	for signal in SIGNALS:
		write_versioned_function(f"api/signals/{signal}", f"""
#> {signal}
#
# @description		Placeholder so the tag always resolves. Add your own function to the tag to react to the event.
#
""", tags=[f"{ns}:v{major}/signals/{signal}"])

