//// trail
//draw_set_color(c_white);

//var count = array_length(trail);

//for (var i = 0; i < count - 1; i++)
//{
//    var p1 = trail[i];
//    var p2 = trail[i + 1];

//    var t = i / (count - 1);

//    // толщина уменьшается
//    var w = lerp(trail_width_start, trail_width_end, t);

//    // прозрачность уменьшается
//    draw_set_alpha(trail_alpha * (1 - t));

//    draw_line_width(
//        p1.x, p1.y,
//        p2.x, p2.y,
//        w
//    );
//}

//draw_set_alpha(1);

// draw apple
draw_self();