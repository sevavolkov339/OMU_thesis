

draw_set_color(door_color);

if (!is_vertical)
{


    // левая дверь
    draw_rectangle(
        x - door_width - gap,
        y - door_height * 0.5,
        x - gap,
        y + door_height * 0.5,
        false
    );

    // правая дверь
    draw_rectangle(
        x + gap,
        y - door_height * 0.5,
        x + door_width + gap,
        y + door_height * 0.5,
        false
    );
}
else
{


    // верхняя дверь
    draw_rectangle(
        x - door_height * 0.5,
        y - door_width - gap,
        x + door_height * 0.5,
        y - gap,
        false
    );

    // нижняя дверь
    draw_rectangle(
        x - door_height * 0.5,
        y + gap,
        x + door_height * 0.5,
        y + door_width + gap,
        false
    );
}