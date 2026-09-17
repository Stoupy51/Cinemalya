# Imports
from beet import Context, Predicate
from stewbeet import set_json_encoder, write_load_file, write_tick_file
from stouputils.typing import JsonDict

from .api import main as api
from .intro.main import main as intro
from .playback.main import main as playback
from .travel.main import main as travel


def same_score(objective: str, target: str, score: str) -> JsonDict:
	""" entity_scores predicate where 'objective' equals the fixed score 'target'.'score'. """
	bound: JsonDict = {"type": "minecraft:score", "target": {"type": "minecraft:fixed", "name": target}, "score": score}
	return {"type": "minecraft:entity_scores", "entity": "this", "scores": {objective: {"min": bound, "max": bound}}}


# Main function is run just before finalyzing the build process (zip, headers, lang, ...)
def beet_default(ctx: Context) -> None:
	ns: str = ctx.project_id
	version: str = ctx.project_version

	# Links a cinematic entity back to the player riding it, without ever touching a UUID
	ctx.data[ns].predicates["has_same_id"] = set_json_encoder(Predicate(same_score(f"{ns}.id", "#player_id", f"{ns}.id")), max_level=-1)

	write_load_file(f"""
# Objectives initialization
scoreboard objectives add {ns}.data dummy
scoreboard objectives add {ns}.id dummy
scoreboard objectives add {ns}.delay dummy
scoreboard objectives add {ns}.frame dummy
scoreboard objectives add {ns}.smoothing dummy
scoreboard objectives add {ns}.ground dummy

# A /reload keeps the entities and their sampled paths, so only the live counter has to be rebuilt
execute store result score #entities {ns}.data if entity @e[tag={ns}.cinematic]
execute unless score #next_id {ns}.id matches 0.. run scoreboard players set #next_id {ns}.id 0
""")

	write_tick_file(f"""
# Cinematic playback (the score gate keeps the selector out of the tick when nothing is playing)
execute if score #entities {ns}.data matches 1.. as @e[type=item_display,tag={ns}.cinematic] at @s run function {ns}:v{version}/playback/tick
""")

	# The public entry points, then everything they call into
	api()
	travel()
	playback()
	intro()

