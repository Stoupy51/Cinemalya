
# 🎬 Cinemalya

[![GitHub](https://img.shields.io/github/v/release/Stoupy51/Cinemalya?logo=github&label=GitHub)](https://github.com/Stoupy51/Cinemalya/releases/latest)
[![Modrinth](https://img.shields.io/modrinth/dt/cinemalya?logo=modrinth&label=Modrinth)](https://modrinth.com/datapack/cinemalya)
[![Discord](https://img.shields.io/discord/1216400498488377467?label=Discord&logo=discord)](https://discord.gg/anxzu6rA9F)
[![Powered by StewBeet](https://img.shields.io/badge/Powered%20by-StewBeet-5865F2?colorA=%23E00000&colorB=%2300A000)](https://stewbeet.paralya.fr/)

🎥 A Minecraft data pack library for flying players through cinematic camera moves.

* ✨ Sweep a player from where they stand to anywhere else, along a curve rather than a straight line.
* 🛤️ Or give it a list of waypoints and let it build a smooth spline passing through every one of them.
* 🎚️ Easing curves, per-waypoint durations, particle trails and a configurable arc.
* 🎯 Rotations sent at full precision, so the camera sweeps instead of turning in 1.4 degree notches.
* 🎞️ A ready-made title card intro: name your scene, place your players, fly them in.
* ⚡ The whole path is computed once at launch. Playback pops one frame per step and does no maths at all.
* 🔌 Signals let your own datapack react when a cinematic starts and ends.
* 🧊 Free flying cameras with no player attached, for cutscenes you drive yourself.
* 🧭 Relative coordinates throughout, so a command block can aim a cinematic with `~` and `^`.

📦 This is an embedded library, so you package it inside your datapack as opposed to having a separate download.
Requires [LanternLoad](https://github.com/LanternMC/load) and the [Bookshelf Spline](https://docs.mcbookshelf.dev/en/latest/modules/spline.html) module to operate.

<br>

# ⚡ Quick start

Package the datapack inside yours, then call a function tag. Every entry point takes a single `with`
compound, so each field inside it stays optional and you only write the ones you care about.

```mcfunction
execute as @s run function #cinemalya:v1/launch {with:{x:19.5,y:82.5,z:23.5,duration:60,arc_side:1,particle:"minecraft:glow"}}
```

That sweeps the player out of where they stand, along an arc, and sets them down on the coordinates you gave.
Everything else is a variation on it:

| I want to | Call |
|---|---|
| Fly a player to some coordinates | [`#cinemalya:v1/launch`](#launch) |
| Aim it from a command block, with `~` and `^` | [`#cinemalya:v1/launch_here`](#launch-here) |
| Fly to wherever an entity is standing | [`#cinemalya:v1/launch_at_entity`](#launch-at-entity) |
| Fly through several waypoints | [`#cinemalya:v1/launch_path`](#launch-path) |
| Open a scene with a title card | [`#cinemalya:v1/intro`](#intro) |
| Cut a cinematic short | [`#cinemalya:v1/stop`](#stop) |
| React when one starts or ends | [signals](#signals) |

A command block wants the second one, because NBT cannot hold a `~`:

```mcfunction
execute positioned ~12 ~8 ~-4 rotated 90 20 as @a[distance=..30] run function #cinemalya:v1/launch_here {with:{duration:60,arc_side:1}}
```

A multi-waypoint path, written the short way:

```mcfunction
execute as @s run function #cinemalya:v1/launch_path {with:{duration:90,ease:"ease_in_out",waypoints:[{args:[-112,75,-21,-30,4]},{args:[-116,77,28,-121,16]},{args:[-72,68,20,92,-11.7]}]}}
```

And a title card that holds on an establishing shot before flying everyone in:

```mcfunction
execute positioned 36.29 102.97 81.36 rotated 145.55 21.76 run function #cinemalya:v1/intro {with:{title:"Warden Forest",subtitle:"by Stoupy",display_time:130,duration:50,particle:"minecraft:glow"}}
```

Then reach for the details:

| Topic | |
|---|---|
| Every option and its default | [argument reference](#options) |
| `[x, y, z, yaw, pitch, duration]` waypoints | [flat waypoints](#flat-waypoints) |
| Waypoints relative to a command block | [relative waypoints](#relative-waypoints) |
| Accelerating and decelerating | [easing a path](#easing) and [a single hop](#easing-hop) |
| Why the camera sweeps instead of notching | [full precision rotation](#precision) |
| Checking whether one is playing | [reading the state](#state) |

# 📚 System explanation

A cinematic is an invisible `item_display` that the player spectates. The library never moves the player directly:
it moves the display, re-issues `/spectate` every tick, and puts the player back down when the path runs out.

When you launch one:

1. 📍 Your arguments become a **waypoint list**. Every waypoint gets a rotation and a duration, inheriting them from its neighbour when you leave them out.
2. 🔄 Yaws are **unwrapped**, so a camera going from `170` to `-170` turns 20 degrees the short way instead of spinning 340 the long way.
3. 📐 The waypoints become **control points**. Two of them get a bezier bending through a raised midpoint; more get a catmull-rom passing through each one.
4. 〰️ Bookshelf samples that curve into a **dense polyline**, four times finer than the frames that will be picked out of it.
5. 🎚️ Each segment then emits exactly as many **frames** as its own duration buys, choosing which sample to land on through the easing curve. A path-level curve lands on the path's ends, so intermediate waypoints are passed at cruising speed rather than eased through one by one.
6. ▶️ Playback pops one frame every `smoothing` ticks. `teleport_duration` on the display makes the client interpolate the gaps, so a step every 2 or 3 ticks still looks continuous.

Doing all the work at launch is what keeps this cheap: a running cinematic costs one macro and two NBT reads per step,
no matter whether its path is 10 frames long or 500.

<br>

# 🔧 Function Tags

Every entry point takes a single `with` compound, so each field inside it stays optional.

<a id="launch"></a>
## 🚀 `#cinemalya:v1/launch`

Fly the player from where they stand to a set of coordinates.

```mcfunction
execute as @s run function #cinemalya:v1/launch {with:{x:19.5,y:82.5,z:23.5,duration:60,arc_side:1,particle:"minecraft:glow"}}
```

`x` / `y` / `z` are **where the player ends up standing**, not where the camera stops. The camera flies to eye height above them and the player is set down on the spot.

<a id="launch-at-entity"></a>
## 🎯 `#cinemalya:v1/launch_at_entity`

Same thing, but the destination is read off another entity, rotation included.

```mcfunction
execute as @s run function #cinemalya:v1/launch_at_entity {with:{target:"@e[tag=my_camera_anchor,limit=1]",duration:60,ease:"ease_in_out"}}
```

<a id="launch-here"></a>
## 🧭 `#cinemalya:v1/launch_here`

Fly the player to wherever the command was aiming. NBT cannot hold a `~`, so `launch` needs absolute
numbers; this one takes its destination from the execution position and rotation instead, which means
every vanilla coordinate form works:

```mcfunction
execute positioned ~12 ~8 ~-4 rotated 90 20 as @a[distance=..30] run function #cinemalya:v1/launch_here {with:{duration:60,arc_side:1}}
```

That is the one a command block wants. Note the order: `positioned` resolves against the **command block**
before `as` swaps the executor, so the destination is fixed relative to the block while each player still
starts from their own feet. `facing` and `^` local coordinates work the same way:

```mcfunction
execute positioned ^ ^2 ^15 facing entity @e[tag=boss,limit=1] run function #cinemalya:v1/launch_here {with:{duration:40,ease:"ease_in_out"}}
```

Like `launch`, the coordinates are where the player ends up **standing**; `yaw` and `pitch` still override
the rotation if you would rather not set it with `rotated`.

<a id="launch-path"></a>
## 🛤️ `#cinemalya:v1/launch_path`

Fly along an explicit list of camera waypoints. Here the positions are **camera positions**, used literally.

```mcfunction
execute as @s run function #cinemalya:v1/launch_path {with:{ease:"ease_in_out",waypoints:[{pos:[0.5,90.0,0.5],rot:[0.0,20.0],duration:40},{pos:[40.5,120.0,60.5],rot:[90.0,35.0],duration:80},{pos:[80.5,75.0,20.5],rot:[180.0,10.0],duration:40}]}}
```

* A waypoint without `rot` keeps the previous one's heading.
* A waypoint without `duration` gets an equal share of the total `duration`.
* Give a single waypoint and the player's own position is used as the starting one.
* `waypoints[0]` is the starting point, so three waypoints mean two segments.

<a id="flat-waypoints"></a>
### Flat waypoints

Writing out `pos` and `rot` for a long path gets noisy, so a waypoint also accepts a single flat `args` list:

```mcfunction
execute as @s run function #cinemalya:v1/launch_path {with:{ease:"ease_in_out",waypoints:[{args:[0,90,0,0,20,40]},{args:[40,120,60,90,35,80]},{args:[80,75,20,180,10]}]}}
```

`args` is `[x, y, z, yaw, pitch, duration]`, and you can stop early at any point:

| Form | Meaning |
|---|---|
| `[x, y, z]` | position only, inheriting the previous heading and an equal share of the duration |
| `[x, y, z, yaw, pitch]` | position and rotation |
| `[x, y, z, yaw, pitch, duration]` | all of it |

Every value goes through a scoreboard on the way in, so plain integers work just as well as decimals.
Mix the two forms freely: `args` is expanded into `pos` and `rot` before anything else looks at the waypoint.

<a id="relative-waypoints"></a>
### Relative waypoints

A waypoint can carry an `at` string instead of a `pos`, resolved through `execute positioned` from
wherever the command ran. Write a whole path relative to a command block and the build it sits in can be
cloned anywhere without touching a single coordinate:

```mcfunction
execute rotated 0 0 run function #cinemalya:v1/launch_path {with:{duration:90,ease:"ease_in_out",waypoints:[{at:"~ ~20 ~",rot:[0,45]},{at:"~30 ~12 ~-30",rot:[135,20]},{at:"^ ^5 ^25",rot:[180,10]}]}}
```

`at` accepts anything the `positioned` argument does: `~` world-relative, `^` local to the execution
rotation, or plain absolute numbers. It overrides `pos` and the position part of `args` when both are given.

Local `^` coordinates need an execution rotation, and a command block has none of its own, so add an
explicit `rotated` when you use them. Resolving happens once at launch against a pair of markers that
capture the position and heading, so every waypoint measures from the same origin rather than from the
previous one.

<a id="easing"></a>
### Easing a path

A path-level `ease` describes **the whole path**, not each hop. It accelerates away from the first waypoint
and settles onto the last, passing every waypoint in between at cruising speed with no change of pace:

```mcfunction
execute as @s run function #cinemalya:v1/launch_path {with:{duration:80,ease:"ease_in_out",waypoints:[{args:[-112,75,-21,-30,4]},{args:[-116,77,28,-121,16]},{args:[-72,68,20,92,-11.7]}]}}
```

The end segments use a curve that arrives at exactly the speed a linear segment travels at, so there is no
visible step where an eased end meets a cruising middle, however many waypoints the path has.

<a id="easing-hop"></a>
### Easing a single hop

Give a waypoint its own `ease` to override the path's for the segment **arriving at** it. Like `duration`,
it describes the hop that ends on that waypoint, so `waypoints[0]` never carries one:

```mcfunction
execute as @s run function #cinemalya:v1/launch_path {with:{duration:80,waypoints:[{args:[-112,75,-21,-30,4]},{args:[-116,77,28,-121,16],ease:"ease_out"},{args:[-72,68,20,92,-11.7],ease:"ease_in"}]}}
```

That one drifts to a near stop on the middle waypoint, holds the beat, then accelerates away to the last:
a deliberate pause on a landmark. Per-waypoint easing always runs the literal curve over that one hop,
which is exactly what you want when the pause is the point.

Combine it with `duration` to control how long the beat lasts:

```mcfunction
execute as @s run function #cinemalya:v1/launch_path {with:{waypoints:[{args:[-112,75,-21,-30,4]},{args:[-116,77,28,-121,16,55],ease:"ease_out"},{args:[-72,68,20,92,-11.7,25],ease:"ease_in"}]}}
```

<a id="stop"></a>
## 🛑 `#cinemalya:v1/stop`

End the cinematic the player is riding, if any.

```mcfunction
execute as @a run function #cinemalya:v1/stop {with:{}}
```

The player is left exactly where the camera was, so **you** decide where they actually belong.
`{with:{restore:false}}` leaves them in spectator too, for when your own code is about to set their gamemode anyway.

<a id="intro"></a>
## 🎞️ `#cinemalya:v1/intro`

The title card: hold on an establishing shot, name the scene, place every player, then fly them all down to where they belong.

```mcfunction
execute positioned 36.29 102.97 81.36 rotated 145.55 21.76 run function #cinemalya:v1/intro {with:{selector:"@a",title:"Warden Forest",subtitle:"by Stoupy",display_time:130,duration:50,particle:"minecraft:glow",target_function:"mypack:maps/warden_forest/spread_one_player"}}
```

Run it **positioned and rotated at the establishing shot**. `target_function` runs `as` each selected player and is where you teleport them to their spot; leave it out and they stay put. Every `launch` field is accepted here too and passed straight through.

<br>

<a id="signals"></a>
# 📡 Signals

Add your own function to these tags to react to a cinematic.

### `#cinemalya:v1/signals/on_launch`

Runs **as and at the player**, just before the camera takes them. This is where to cancel anything of yours that a teleport should interrupt: parkour timers, combat tags, checkpoint tracking.

```mcfunction
#> mypack:cinemalya/on_launch
execute if entity @s[tag=mypack.jump_timing] run function mypack:player/jump_timer/cancel
```

### `#cinemalya:v1/signals/on_finish`

Runs **as and at the player**, once they have been set down and given their gamemode back.

<br>

<a id="options"></a>
# 📋 Argument reference

| Field | Type | Default | Meaning |
|---|---|---|---|
| `duration` | int | `60` | Total length of the travel, in ticks |
| `smoothing` | int | `2` | Ticks between frames. Higher is cheaper and softer, lower is sharper |
| `delay` | int | `0` | Ticks to hold still before the camera starts moving |
| `ease` | string | `"linear"` | `"linear"`, `"ease_in"`, `"ease_out"`, `"ease_in_out"`. On a path it shapes the whole travel; on a waypoint it shapes only the hop arriving there |
| `spline` | string | auto | `"bezier"` or `"catmull_rom"`. Defaults to bezier for two waypoints, catmull-rom beyond |
| `arc_side` | float | `0.0` | How far to swing sideways, as a fraction of half the distance. `0` flies straight |
| `arc_height` | float | `20.0` | How far above the higher end the arc peaks |
| `particle` | string | none | A particle id trailed behind the camera, e.g. `"minecraft:glow"` |
| `gamemode` | string | `"restore"` | `"restore"`, `"keep"` (player is already spectator), `"none"` (no player at all) |
| `tags` | list | `[]` | Extra tags put on the cinematic entity, so your selectors can find it |
| `precise_rotation` | bool | `true` | Send rotations at full precision instead of 1.40625 degree steps |
| `yaw` / `pitch` | float | target's | Override the rotation the camera ends on |

`launch` also takes `x` / `y` / `z`, `launch_at_entity` takes `target`, `launch_here` takes none of them (it reads the execution position), and `launch_path` takes `waypoints`.
`yaw` / `pitch` apply to `launch`, `launch_at_entity` and `intro`. On `launch_path` each waypoint carries its own `rot` instead.

<br>

<a id="precision"></a>
# 🎯 Full precision rotation

Minecraft sends entity rotations to the client quantised to steps of `360/256`, or `1.40625` degrees.
On a `/spectate` camera that is very visible: the view turns in notches instead of sweeping ([MC-184359](https://bugs.mojang.com/browse/MC-184359)).

Cinemalya works around it. Flipping the camera's `OnGround` flag to the opposite of its previous value
makes the server send that tick's rotation at full precision instead:

```mcfunction
execute store success entity @s OnGround byte 1 store success score @s cinemalya.ground unless score @s cinemalya.ground matches 1
```

This is on by default and costs one command per cinematic per tick. Display entities are not living entities,
so nothing else in the game reads that flag and there is no side effect to pay for.

It leans on [MC-278440](https://bugs.mojang.com/browse/MC-278440), a bug found by the community while investigating
rotation drift, so a future Minecraft version could close it. Pass `precise_rotation:false` to turn it off.

<br>

<a id="state"></a>
# 🔍 Reading the library's state

| Score                      | Meaning                                   |
|----------------------------|-------------------------------------------|
| `#entities cinemalya.data` | How many cinematics are playing right now |

Gate your own logic on it when you need to wait for an intro to finish:

```mcfunction
execute if score #entities cinemalya.data matches 1.. run return 1
```

Entities carry the `cinemalya.cinematic` tag, plus whatever you passed in `tags`.

