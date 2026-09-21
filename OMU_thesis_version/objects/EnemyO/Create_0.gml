

//speed = 1
hp = 3

path = path_add();

target_x = PlayerBallerO.x
target_y = PlayerBallerO.y



alarm[0] = 1


shake_strength = 0;
shake_duration = 1; // 1 чтобы не было деления на ноль
shake_timer = 0;
shake_offset_x = 0;
shake_offset_y = 0;

// collision logic
touching_ball = false;

// откинут шипами PuffFishO, своя логика движения на это время отключается
puff_stunned = false;

// for effects
draw_ox = 0;
draw_oy = 0;

// how many apples drops by default
apple_base = 3; 


// walk

walk_timer = 0;
walk_speed = 0.08;
walk_bounce_height = 2;
walk_tilt_amount = 8;
walk_squash = 0;
walk_squash_speed = 0;
walk_squash_stiffness = 0.35;
walk_squash_damping = 0.55;
walk_side = 1;
walk_bounce_prev = 0;

walk_sx = 1;
walk_sy = 1;
walk_angle = 0;
walk_y_offset = 0;