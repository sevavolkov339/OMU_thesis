//parent_obj = noone;
//alpha = 0.4;
//fade_speed = 0.018;
//_sprite = -1;
//_sub_image = 0;
//_xscale = 1;
//_yscale = 1;
//_angle = 0;

parent_obj = noone;
trail_points = array_create(0);
max_points = 20;
point_interval = 2;
point_timer = 0;

// байер для дизера
bayer = [
     0,  8,  2, 10,
    12,  4, 14,  6,
     3, 11,  1,  9,
    15,  7, 13,  5
];