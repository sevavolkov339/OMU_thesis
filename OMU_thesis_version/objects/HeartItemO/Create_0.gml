vx = random_range(-1.5, 1.5);
vy = random_range(2, 5);
if (vx == 0 && vy == 0) vx = 1;

squish_x = 1;
squish_y = 1;
squish_x_speed = 0;
squish_y_speed = 0;
squish_stiffness = 0.2;
squish_damping = 0.5;
squish_white = 0;
collecting = false;