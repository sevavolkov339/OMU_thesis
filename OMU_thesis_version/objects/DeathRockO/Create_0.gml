real_angle = 0; // реальный угол вращения
spin_speed = 5; // градусов в шаг
image_angle = 0;

// зона движения, берём из AllowedZoneO, если он есть в комнате
zone_x1 = 0;
zone_y1 = 0;
zone_x2 = room_width;
zone_y2 = room_height;
if (instance_exists(AllowedZoneO)) {
    // читаем bbox напрямую, не полагаясь на то, что Create-событие AllowedZoneO уже
    zone_x1 = AllowedZoneO.bbox_left;
    zone_y1 = AllowedZoneO.bbox_top;
    zone_x2 = AllowedZoneO.bbox_right;
    zone_y2 = AllowedZoneO.bbox_bottom;
}

// углы зоны по часовой стрелке: верх-лево -> верх-право -> низ-право -> низ-лево
corners = [
    [zone_x1, zone_y1],
    [zone_x2, zone_y1],
    [zone_x2, zone_y2],
    [zone_x1, zone_y2]
];
// исходная позиция, в которую камень поместили в комнате, по ней ищем ближайший
var _orig_x = x;
var _orig_y = y;
var _dists = [
    point_distance(_orig_x, _orig_y, corners[0][0], corners[0][1]),
    point_distance(_orig_x, _orig_y, corners[1][0], corners[1][1]),
    point_distance(_orig_x, _orig_y, corners[2][0], corners[2][1]),
    point_distance(_orig_x, _orig_y, corners[3][0], corners[3][1])
];

// берём ближайший угол, который ещё не занят другим DeathRockO в этой комнате
corner_index = 0;
var _best_dist = infinity;
for (var i = 0; i < 4; i++) {
    var _taken = false;
    with (DeathRockO) {
        if (id != other.id && corner_index == i) _taken = true;
    }
    if (!_taken && _dists[i] < _best_dist) {
        _best_dist = _dists[i];
        corner_index = i;
    }
}

// стартуем прямо в выбранном угле
x = corners[corner_index][0];
y = corners[corner_index][1];

// движение между углами
state = "moving"; // "moving", едем к следующему углу, "shaking", трясёмся после "удара о стену"
move_speed = 0;
move_accel = 0.2; // ускорение за шаг
move_max_speed = 14; // предел скорости разгона

// тряска при ударе об угол (она же, пауза на углу)
shake_duration = room_speed * 1.5; // 1.5 секунды
shake_timer = 0;
shake_strength = 4;
shake_x = 0;
shake_y = 0;
