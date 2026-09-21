// create grid
grid = mp_grid_create(0,0,room_width, room_height, 1, 1)
// add walls to grid
mp_grid_add_instances(grid, WallForEnemiesO, 0);

// coarser grid for the test enemies, 1px is too fine to walk by hand
cell_size = 24;
grid_w = ceil(room_width / cell_size);
grid_h = ceil(room_height / cell_size);

// keeps enemies off wall corners, matches EnemyFlyS's own half-width
wall_clearance = 10;

function clear_line_with_margin(_x1, _y1, _x2, _y2) {
    if (collision_line(_x1, _y1, _x2, _y2, WallForEnemiesO, true, true) != noone) return false;
    var _perp = point_direction(_x1, _y1, _x2, _y2) + 90;
    var _ox = lengthdir_x(wall_clearance, _perp);
    var _oy = lengthdir_y(wall_clearance, _perp);
    if (collision_line(_x1 + _ox, _y1 + _oy, _x2 + _ox, _y2 + _oy, WallForEnemiesO, true, true) != noone) return false;
    if (collision_line(_x1 - _ox, _y1 - _oy, _x2 - _ox, _y2 - _oy, WallForEnemiesO, true, true) != noone) return false;
    return true;
}

// coarse_grid/waypoint-граф строятся сканированием живых инстансов WallForEnemiesO на момент
function rebuild_coarse_pathing() {
    // tried inflating whole cells for this earlier, blocked most of the map
    coarse_grid = array_create(grid_w);
    for (var gx = 0; gx < grid_w; gx++) {
        coarse_grid[gx] = array_create(grid_h, 0);
    }
    for (var gx = 0; gx < grid_w; gx++) {
        for (var gy = 0; gy < grid_h; gy++) {
            var _wx = gx * cell_size + cell_size / 2;
            var _wy = gy * cell_size + cell_size / 2;
            if (instance_position(_wx, _wy, WallForEnemiesO) != noone) {
                coarse_grid[gx][gy] = 1;
            }
        }
    }

    // waypoint graph for navmesh - sample open spots, connect ones that see each other
    waypoint_x = [];
    waypoint_y = [];
    var _step = 3; // ~72px apart at cell_size 24
    for (var gx = 1; gx < grid_w - 1; gx += _step) {
        for (var gy = 1; gy < grid_h - 1; gy += _step) {
            if (coarse_grid[gx][gy] == 0) {
                array_push(waypoint_x, gx * cell_size + cell_size / 2);
                array_push(waypoint_y, gy * cell_size + cell_size / 2);
            }
        }
    }

    var _wp_count = array_length(waypoint_x);
    var _max_edge_dist = cell_size * (_step + 1) * 1.6;
    waypoint_edges = array_create(_wp_count);
    for (var i = 0; i < _wp_count; i++) {
        waypoint_edges[i] = [];
        for (var j = 0; j < _wp_count; j++) {
            if (i == j) continue;
            if (point_distance(waypoint_x[i], waypoint_y[i], waypoint_x[j], waypoint_y[j]) > _max_edge_dist) continue;
            if (clear_line_with_margin(waypoint_x[i], waypoint_y[i], waypoint_x[j], waypoint_y[j])) {
                array_push(waypoint_edges[i], j);
            }
        }
    }
}

rebuild_coarse_pathing();

// shared flow field for Test_4, rebuilt in Step_0 every 10 frames like the others
flow_dir = array_create(grid_w);
for (var gx = 0; gx < grid_w; gx++) {
    flow_dir[gx] = array_create(grid_h, -1);
}
flow_field_timer = 0;
