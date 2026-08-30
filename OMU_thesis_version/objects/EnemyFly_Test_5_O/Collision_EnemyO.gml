var _push_dir = point_direction(other.x, other.y, x, y);
var _len = lerp(2, 0, point_distance(other.x, other.y, x, y)/max(abs(sprite_width),abs(sprite_height)));
repeat(2) {
    var _x = x + lengthdir_x(_len, _push_dir);
    var _y = y + lengthdir_y(_len, _push_dir);
    if(place_free(_x, _y)) {
        x = _x;
        y = _y;
    }
}

