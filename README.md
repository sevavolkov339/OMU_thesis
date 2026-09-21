# OMU

A top-down roguelike I make on my own in GameMaker Studio 2. You kick loose objects at
enemies, clear ten procedurally generated rooms and then fight a boss.

This repository is the version used for my bachelor thesis. Three of the game's systems are
built in several variants and benchmarked against each other inside the game itself:

* pathfinding for the flying enemies (Dijkstra, A*, JPS, flow field, navmesh)
* saving and loading a run (INI, JSON, binary, each as a full snapshot or a delta log)
* room generation (procedural placement, BSP, WaveFunctionCollapse)

The game ships with A*, BSP and binary full snapshots, which is what came out of the
measurements in `benchmark_data/`.

## Running the game

Open `OMU_thesis_version/OMU_thesis_version.yyp` in GameMaker and press Run. The game starts
in `Main_Menu_Room`: pick a save slot and play. I used GameMaker IDE 2026.0.0.16 with runtime
2026.0.0.23 in VM mode, and every number in the thesis comes from that setup.

Keyboard and mouse or a gamepad both work; the game switches on whichever was used last.

## Running the benchmarks

Each benchmark lives in its own room with its own controller object. Open the Room Manager,
drag the room you want to the top of the room order, and press Run. The benchmark starts by
itself, draws its progress in the corner, and when it is finished it prints `done` together
with the full path of the CSV file it wrote. That path is the game's working directory
(on macOS `~/Library/Application Support/<game name>/`).

| Room | Controller | What it measures | File | Runs |
| --- | --- | --- | --- | --- |
| `Testing_Room` | `BenchmarkControllerO` | five pathfinding methods, 10 to 100 enemies in steps of 10, 30 trials each | `pathfinding_benchmark.csv` | 1500, about half an hour |
| `Testing_SaveLoad_Room` | `SaveLoadBenchmarkO` | three formats crossed with two write strategies, over a simulated run 20 levels deep, 30 trials | `saveload_benchmark.csv` | 3600 rows, a few minutes |
| `Testing_LevelGen_Room` | `LevelGenBenchmarkO` | three generators, twelve wall targets, 30 trials each | `levelgen_benchmark.csv` | 1080, a few minutes |

The five pathfinding variants are separate copies of the flying enemy, so each one can be
read on its own: `EnemyFly_Test_1_O` is Dijkstra, `_2` is A*, `_3` is JPS, `_4` is the flow
field and `_5` is the navmesh. The room holds a fixed wall layout and one stationary dummy,
`PlayerTestO`, so nothing but the search itself is being timed.

## Logging a real playthrough

The three rooms above measure one system at a time in isolation. To measure all of them
during normal play, put exactly one logger object into `Main_Menu_Room` and play a full run:
ten generated levels and the boss, saving and reloading after levels 1, 4, 8 and at the boss.
The logger writes one row per event to `pipeline_validation_c.csv`.

| Object | Pathfinding | Generator |
| --- | --- | --- |
| `PipelineValidationO` | A* | BSP |
| `PipelineValidationO_1` | A* | BSP |
| `PipelineValidationO_2` | A* | procedural placement |
| `PipelineValidationO_3` | flow field | BSP |
| `PipelineValidationO_4` | flow field | procedural placement |
| `PipelineValidationO_5` | flow field | BSP, plus the flow field diagnostic |
| `PipelineValidationO_6` | flow field | procedural placement, plus the diagnostic |

The two diagnostic objects also write `pipeline_validation_diag.csv`: after every flow field
rebuild they build a second field that visits only the cells the flood fill actually reached,
time it, and check that it gives the same directions.

Only one logger may be alive at a time, and the configuration has to be set before the first
level is generated, which is why it sits in the main menu room.

## Where things are

| Path | What it holds |
| --- | --- |
| `objects/EnemyFlyO` | the enemy the game uses, running A* on the coarse grid |
| `objects/SetupPathwayO` | pathing grids, the waypoint graph and the flow field |
| `objects/CombatRoomControllerO` | level generation and restoring a level from a save |
| `objects/GameControllerO` | run state, `save_game()` and `load_game()` |
| `scripts/AstarFindPathScr` | A* search |
| `scripts/GenerateProceduralRoomScr`, `GenerateBSPRoomScr`, `GenerateWFCRoomScr` | the three generators |
| `scripts/SaveFormatIniScr`, `SaveFormatBinaryScr` | INI and binary save formats; JSON uses the engine's own calls |

## Data

`benchmark_data/` holds the CSV files the thesis analyses, exactly as the game wrote them.

| File | Contents |
| --- | --- |
| `pathfinding_benchmark.csv` | one row per trial: method, enemy count, mean time of a path recalculation |
| `saveload_benchmark.csv` | one row per trial: format, strategy, run depth, write time, read time, file size |
| `levelgen_benchmark.csv` | one row per trial: generator, wall target, generation time, what was actually placed |
| `pipeline_stage1_validation.csv` | ten logged playthroughs of A* + BSP + binary; the thesis uses nine, the tenth started logging late |
| `pipeline_stage2_configurations.csv` | seventeen playthroughs across C1 to C4, plus the two diagnostic runs |
| `pipeline_stage2_flowfield_diagnostic.csv` | per level: rebuilds, normal field time, reached-cells-only time, cells reached |
