
# 🎬 Cinemalya

[![GitHub](https://img.shields.io/github/v/release/Stoupy51/Cinemalya?logo=github&label=GitHub)](https://github.com/Stoupy51/Cinemalya/releases/latest)
[![Modrinth](https://img.shields.io/modrinth/dt/cinemalya?logo=modrinth&label=Modrinth)](https://modrinth.com/datapack/cinemalya)
[![Discord](https://img.shields.io/discord/1216400498488377467?label=Discord&logo=discord)](https://discord.gg/anxzu6rA9F)
[![Powered by StewBeet](https://img.shields.io/badge/Powered%20by-StewBeet-5865F2?colorA=%23E00000&colorB=%2300A000)](https://stewbeet.paralya.fr/)

🎥 A Minecraft data pack library for flying players through cinematic camera moves.

* ✨ Sweep a player anywhere along a spline, with easing, arcs and particle trails.
* 🎞️ A ready-made title card intro, and signals to hook your own logic in.
* 🧭 Works from a command block: `~` and `^` coordinates throughout.
* 🎯 Rotations sent at full precision, so the camera sweeps instead of notching.
* ⚡ The path is computed once at launch; playback just pops a frame per step.

📦 Embedded library: package it inside your datapack rather than shipping it separately.
Requires [LanternLoad](https://github.com/LanternMC/load) and [Bookshelf Spline](https://docs.mcbookshelf.dev/en/latest/modules/spline.html).

<br>

# ⚡ Quick start

```mcfunction
execute as @s run function #cinemalya:v1/launch {with:{x:19.5,y:82.5,z:23.5,duration:60,arc_side:1,particle:"minecraft:glow"}}
```

Every entry point takes one `with` compound, so each field inside stays optional.

| I want to                               | Call                                    |
|-----------------------------------------|-----------------------------------------|
| Fly a player to some coordinates        | [`launch`](#launch)                     |
| Aim from a command block with `~` / `^` | [`launch_here`](#launch-here)           |
| Fly to where an entity stands           | [`launch_at_entity`](#launch-at-entity) |
| Fly through several waypoints           | [`launch_path`](#launch-path)           |
| Open a scene with a title card          | [`intro`](#intro)                       |
| Cut a cinematic short                   | [`stop`](#stop)                         |
| React when one starts or ends           | [signals](#signals)                     |
| Tune anything                           | [options](#options)                     |

<br>

# 🔧 Entry points

<a id="launch"></a>
### `#cinemalya:v1/launch`

```mcfunction
execute as @s run function #cinemalya:v1/launch {with:{x:19.5,y:82.5,z:23.5,duration:60,arc_side:1}}
```

`x` / `y` / `z` are where the player ends up **standing**, not where the camera stops.

<a id="launch-here"></a>
### `#cinemalya:v1/launch_here`

Destination comes from the execution position and rotation, so relative coordinates work. NBT cannot hold a `~`, which is why `launch` needs absolute numbers and this one exists.

```mcfunction
execute positioned ~12 ~8 ~-4 rotated 90 20 as @a[distance=..30] run function #cinemalya:v1/launch_here {with:{duration:60,arc_side:1}}
```

Mind the order: `positioned` resolves against the command block *before* `as` swaps the executor, so the destination is fixed while each player still starts from their own feet. `facing` and `^` work too.

<a id="launch-at-entity"></a>
### `#cinemalya:v1/launch_at_entity`

```mcfunction
execute as @s run function #cinemalya:v1/launch_at_entity {with:{target:"@e[tag=camera_anchor,limit=1]",duration:60,ease:"ease_in_out"}}
```

<a id="launch-path"></a>
### `#cinemalya:v1/launch_path`

Fly through explicit waypoints. Here the positions are **camera positions**, used literally.

```mcfunction
execute as @s run function #cinemalya:v1/launch_path {with:{duration:90,ease:"ease_in_out",waypoints:[{args:[-112,75,-21,-30,4]},{args:[-116,77,28,-121,16]},{args:[-72,68,20,92,-11.7]}]}}
```

`waypoints[0]` is the starting point, so three waypoints mean two segments. Give just one and the player's own position starts the path. A waypoint may be written three ways:

| Key | Example | |
|---|---|---|
| `args` | `{args:[x,y,z,yaw,pitch,duration]}` | Flat, stop early at 3 or 5. Integers are fine |
| `pos` / `rot` | `{pos:[0.5,90.0,0.5],rot:[0.0,20.0]}` | Explicit |
| `at` | `{at:"~30 ~12 ~-30",rot:[135,20]}` | Relative to where the command ran, `~` or `^` |

Missing `rot` keeps the previous heading; missing `duration` takes an equal share of the total. `at` overrides `pos`. Local `^` needs an execution rotation, so add `rotated` when using it from a command block.

**Easing.** A path-level `ease` shapes the *whole* travel: it accelerates off the first waypoint, cruises through the middle ones at a steady pace, and settles onto the last. Put `ease` on a waypoint instead to shape only the hop arriving there:

```mcfunction
execute as @s run function #cinemalya:v1/launch_path {with:{waypoints:[{args:[-112,75,-21,-30,4]},{args:[-116,77,28,-121,16,55],ease:"ease_out"},{args:[-72,68,20,92,-11.7,25],ease:"ease_in"}]}}
```

That drifts to a near stop on the middle waypoint, holds the beat, then accelerates away.

<a id="intro"></a>
### `#cinemalya:v1/intro`

Hold on an establishing shot, name the scene, place every player, fly them all in. Run it **positioned and rotated** at the shot.

```mcfunction
execute positioned 36.29 102.97 81.36 rotated 145.55 21.76 run function #cinemalya:v1/intro {with:{title:"Warden Forest",subtitle:"by Stoupy",display_time:130,duration:50}}
```

`target_function` runs as each player and is where you teleport them to their spot; omit it and they stay put. Also takes `selector`, `sound`, `title_color`, `subtitle_color`, and every `launch` field.

<a id="stop"></a>
### `#cinemalya:v1/stop`

```mcfunction
execute as @a run function #cinemalya:v1/stop {with:{}}
```

The player is left exactly where the camera was, so you decide where they belong. `restore:false` leaves them in spectator too.

<br>

<a id="options"></a>
# 📋 Options

| Field              | Type   | Default     | Meaning                                                   |
|--------------------|--------|-------------|-----------------------------------------------------------|
| `duration`         | int    | `60`        | Length of the travel, in ticks                            |
| `smoothing`        | int    | `2`         | Ticks between frames. Higher is cheaper and softer        |
| `delay`            | int    | `0`         | Ticks to hold still before moving                         |
| `ease`             | string | `"linear"`  | `linear`, `ease_in`, `ease_out`, `ease_in_out`            |
| `spline`           | string | auto        | `bezier` (2 waypoints) or `catmull_rom` (more)            |
| `arc_side`         | float  | `0.0`       | Sideways swing, as a fraction of half the distance        |
| `arc_height`       | float  | `20.0`      | How far above the higher end the arc peaks                |
| `particle`         | string | none        | Particle trailed behind the camera                        |
| `gamemode`         | string | `"restore"` | `restore`, `keep` (already spectator), `none` (no player) |
| `tags`             | list   | `[]`        | Extra tags on the cinematic entity                        |
| `precise_rotation` | bool   | `true`      | See [rotation precision](#precision)                      |
| `yaw` / `pitch`    | float  | target's    | Override the ending rotation                              |

Per entry point: `launch` takes `x`/`y`/`z`, `launch_at_entity` takes `target`, `launch_path` takes `waypoints`, `launch_here` takes neither. `yaw`/`pitch` do not apply to `launch_path`, where each waypoint carries its own `rot`.

<br>

<a id="signals"></a>
# 📡 Signals

Add your own function to these tags. Both run **as and at the player**.

| Tag                               | When                                              |
|-----------------------------------|---------------------------------------------------|
| `#cinemalya:v1/signals/on_launch` | Just before the camera takes them. Cancel parkour timers, combat tags, anything a teleport should interrupt |
| `#cinemalya:v1/signals/on_finish` | Once they are set down and their gamemode is back |

<br>

# 🔍 Notes

**Reading the state.** `#entities cinemalya.data` counts the cinematics playing right now, so you can gate on it (`execute if score #entities cinemalya.data matches 1.. run return 1`). Camera entities carry the `cinemalya.cinematic` tag plus whatever you passed in `tags`.

<a id="precision"></a>
**Rotation precision.** Minecraft quantises rotations to steps of `360/256` = `1.40625°`, which makes a `/spectate` camera turn in visible notches ([MC-184359](https://bugs.mojang.com/browse/MC-184359)). Flipping the camera's `OnGround` flag each tick makes the server send full precision instead. On by default, one command per cinematic per tick, no side effect since display entities are not living entities. It relies on [MC-278440](https://bugs.mojang.com/browse/MC-278440), a community find, so a future version could close it: pass `precise_rotation:false` to opt out.

**How it works.** A cinematic is an invisible `item_display` the player spectates. Your waypoints become spline control points, Bookshelf samples them into a dense polyline, and each segment picks exactly as many frames as its duration buys. All of that happens once at launch, so playback costs one macro and two NBT reads per step whether the path is 10 frames or 500.

