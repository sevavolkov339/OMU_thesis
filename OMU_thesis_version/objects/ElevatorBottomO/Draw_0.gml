// draw doors
draw_set_color(c_white);

// центр по X, низ лифта по Y
var door_x = (bbox_left + bbox_right) * 0.5;
var door_y = bbox_top + 10;

if (!is_vertical)
{
    // горизонтальные двери влево / вправо
    draw_rectangle(
        door_x - door_width - gap,
        door_y - door_height,
        door_x - gap,
        door_y,
        false
    );

    draw_rectangle(
        door_x + gap,
        door_y - door_height,
        door_x + door_width + gap,
        door_y,
        false
    );
}
else
{
    // вертикальные двери вверх / вниз
    draw_rectangle(
        door_x - door_height * 0.5,
        door_y - door_width - gap,
        door_x + door_height * 0.5,
        door_y - gap,
        false
    );

    draw_rectangle(
        door_x - door_height * 0.5,
        door_y + gap,
        door_x + door_height * 0.5,
        door_y + door_width + gap,
        false
    );
}

// draw elevator
//draw_self();
draw_sprite_ext(
    sprite_index,
    image_index,
    x + shake_offset_x,
    y + shake_offset_y,
    image_xscale,
    image_yscale,
    image_angle,
    c_white,
    image_alpha
);