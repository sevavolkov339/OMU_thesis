//sprite_index = HealthS;
//phase = "grow";
//timer = 0;

//// scale пружина (squash & stretch)
//scale_x = 0.1;
//scale_y = 0.1;
//scale_vx = 2.0;  // начальный импульс — быстро вырастает
//scale_vy = 2.0;
//scale_target = 5;
//stiffness = 0.22;
//damping = 0.55;

//// цвет: жёлтый -> белый
//col_r = 1.0;
//col_g = 1.0;
//col_b = 0.0;

//// мигание и исчезновение
//blink_timer = 0;
//blink_duration = 60; // сколько длится фаза мигания
//blink_visible = true;
//alpha = 1.0;

//spawn bubbles
//var _spread = random_range(0, 100);
//var b1 = instance_create_layer(x - _spread, y + random_range(-4, 4), "UIL", ChillBubbleO);
//var b2 = instance_create_layer(x + _spread, y + random_range(-4, 4), "UIL", ChillBubbleO);
//show_debug_message("Bubble spawn x: " + string(x) + " spread: " + string(_spread));

//instance_destroy();