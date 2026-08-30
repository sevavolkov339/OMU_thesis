// состояние
state = "idle"; // idle, spin, result, win
spin_timer = 0;
spin_duration = 0.5 * room_speed;
win_chance = 0.50;
cost = 10;

// squish
squish_x = 1;
squish_y = 1;
squish_x_speed = 0;
squish_y_speed = 0;
squish_stiffness = 0.3;
squish_damping = 0.6;

// тряска
shake_timer = 0;
shake_duration = 0.3 * room_speed;
shake_strength = 3;
kick_shake_timer = 0;
kick_shake_duration = 0.2 * room_speed;

// позиция и физика
base_x = x;
base_y = y;
origin_x = x;
origin_y = y;
vel_x = 0;
vel_y = 0;
friction_spd = 0.92;

// пружина смещения от игрока
offset_x = 0;
offset_y = 0;
offset_vel_x = 0;
offset_vel_y = 0;
push_stiffness = 0.15;
push_damping = 0.7;
was_touching_player = false;

// конфети
confetti = [];

// маска
mask_index = SlotMachineS;
changelayerpoint = origin_y - 30

instance_create_layer(x,y,"PlayerL",WallFollowMachineO);