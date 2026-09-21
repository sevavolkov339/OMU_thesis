// draw elevator first
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


// vertical doors right

draw_set_color(c_white);

// правая грань лифта
var door_x = bbox_right - 11; // doors outside elevator

// центр по Y
var door_center_y = (bbox_top + bbox_bottom) * 0.5;

// размеры
var door_thickness = door_height; 
var door_len = door_width;       

// верхняя дверь (уезжает вверх)
draw_rectangle(
    door_x,
    door_center_y - door_len - gap,
    door_x + door_thickness,
    door_center_y - gap,
    false
);

// нижняя дверь (уезжает вниз)
draw_rectangle(
    door_x,
    door_center_y + gap,
    door_x + door_thickness,
    door_center_y + door_len + gap,
    false
);