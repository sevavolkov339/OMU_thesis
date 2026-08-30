function AstarFindPathScr(sx, sy, ex, ey)
{
	// sx/sy/ex/ey are grid cells, not room pixels - caller converts
	var grid = SetupPathwayO.coarse_grid
	var w = SetupPathwayO.grid_w
	var h = SetupPathwayO.grid_h
	
	var open = []
	var closed = []
	
	function heuristic(x1, y1, x2, y2) {
		return abs(x1 - x2) + abs(y1 - y2) // Manhattan
	}
	
	function node_in_list(list, x, y) {
		for (var i = 0; i < array_length(list); i++) {
			if (list[i].x == x && list[i].y == y) return i
		}
		return -1
	}
	
	// Проверка границ
	if (sx < 0 || sx >= w || sy < 0 || sy >= h) return []
	if (ex < 0 || ex >= w || ey < 0 || ey >= h) return []
	
	// Проверяем, что начальная и конечная точки не в стенах
	if (grid[sx][sy] == 1) return [] // Начальная точка в стене
	if (grid[ex][ey] == 1) return [] // Конечная точка в стене
	
	// Если начальная и конечная точки совпадают
	if (sx == ex && sy == ey) {
		return [] // Не нужно двигаться
	}
	
	var start = {
		x : sx, y : sy,
		g : 0,
		h : heuristic(sx, sy, ex, ey),
		f : 0,
		parent : -1
	}
	start.f = start.g + start.h
	
	array_push(open, start)
	
	var max_iterations = 1000
	var iterations = 0
	
	while (array_length(open) > 0 && iterations < max_iterations)
	{
		iterations++
		
		// берём узел с минимальным f
		var current = 0
		for (var i = 1; i < array_length(open); i++) {
			if (open[i].f < open[current].f)
				current = i
		}
		
		var node = open[current]
		array_delete(open, current, 1)
		var closed_index = array_length(closed)
		array_push(closed, node)
		
		// достигли цели
		if (node.x == ex && node.y == ey)
		{
			var path = []
			var current_node = node
			
			// Восстанавливаем путь от конца к началу
			while (current_node.parent != -1) {
				array_push(path, [current_node.x, current_node.y])
				var parent_index = current_node.parent
				if (parent_index >= 0 && parent_index < array_length(closed)) {
					current_node = closed[parent_index]
				} else {
					break
				}
			}
			
			// НЕ добавляем начальную точку, так как враг уже там
			// Переворачиваем путь
			array_reverse(path)
			
			return path
		}
		
		// соседи (8 направлений: 4 прямых + 4 диагональных)
		var dirs = [
			[1, 0, 1.0],      // право
			[-1, 0, 1.0],    // лево
			[0, 1, 1.0],     // вниз
			[0, -1, 1.0],    // вверх
			[1, 1, 1.414],   // право-вниз (диагональ)
			[-1, 1, 1.414],  // лево-вниз (диагональ)
			[1, -1, 1.414],  // право-вверх (диагональ)
			[-1, -1, 1.414]  // лево-вверх (диагональ)
		]
		
		for (var d = 0; d < array_length(dirs); d++)
		{
			var nx = node.x + dirs[d][0]
			var ny = node.y + dirs[d][1]
			var move_cost = dirs[d][2]
			
			// Проверка границ
			if (nx < 0 || ny < 0 || nx >= w || ny >= h) continue
			
			// Проверка препятствий
			if (grid[nx][ny] == 1) continue
			
			// Для диагоналей проверяем, что соседние ячейки тоже свободны
			if (move_cost > 1.0) {
				var check_x1 = node.x
				var check_y1 = ny
				var check_x2 = nx
				var check_y2 = node.y
				
				if (check_x1 >= 0 && check_x1 < w && check_y1 >= 0 && check_y1 < h) {
					if (grid[check_x1][check_y1] == 1) continue
				}
				if (check_x2 >= 0 && check_x2 < w && check_y2 >= 0 && check_y2 < h) {
					if (grid[check_x2][check_y2] == 1) continue
				}
			}
			
			// Проверяем, не в закрытом ли списке
			if (node_in_list(closed, nx, ny) != -1) continue
			
			var g = node.g + move_cost
			var h_val = heuristic(nx, ny, ex, ey)
			var f = g + h_val
			
			var index = node_in_list(open, nx, ny)
			if (index == -1) {
				// Добавляем новый узел
				array_push(open, {
					x : nx, y : ny,
					g : g, h : h_val, f : f,
					parent : closed_index
				})
			}
			else if (g < open[index].g) {
				// Обновляем существующий узел, если нашли лучший путь
				open[index].g = g
				open[index].f = f
				open[index].parent = closed_index
			}
		}
	}
	
	return [] // путь не найден
}