var vw = display_get_gui_width();
var vh = display_get_gui_height();

draw_set_color(c_white);

for (var i = 0; i < array_length(lines); i++)
{
    var l = lines[i];

    draw_set_alpha(l.alpha);

    var thickness = 2; //line width

    draw_rectangle(
        l.x - thickness * 0.5,
        l.y,
        l.x + thickness * 0.5,
        l.y + l.len,
        false
    );
}

draw_set_alpha(1);

//white screen overlay
if (white_alpha > 0)
{
    draw_set_color(c_white);
    draw_set_alpha(white_alpha);

    draw_rectangle(
        0, 0,
        display_get_gui_width(),
        display_get_gui_height(),
        false
    );

    draw_set_alpha(1);
}