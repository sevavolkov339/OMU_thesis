function collision_normal(x, y, obj, radius=4, spacing=1)
{
    var nx = 0;
    var ny = 0;
    if (collision_circle(x, y, radius, obj, true, true) != noone) {
        for (var j=spacing; j<=radius; j+=spacing) {
            for (var i=0; i<radius; i+=spacing) {
                if (point_distance(0, 0, i, j) <= radius) {
                    if (collision_point(x+i, y+j, obj, true, true) == noone) { nx += i; ny += j; }
                    if (collision_point(x+j, y-i, obj, true, true) == noone) { nx += j; ny -= i; }
                    if (collision_point(x-i, y-j, obj, true, true) == noone) { nx -= i; ny -= j; }
                    if (collision_point(x-j, y+i, obj, true, true) == noone) { nx -= j; ny += i; }
                }
            }
        }
        if (nx == 0 && ny == 0) return (-1);
        return point_direction(0, 0, nx, ny);
    }
    return (-1);
}