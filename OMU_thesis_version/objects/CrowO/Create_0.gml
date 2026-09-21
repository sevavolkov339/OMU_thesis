owner = PlayerBallerO;

damage = 0.5;

// "насест", своя точка возле игрока, за которую ворона держится, а не летает
perch_dist = random_range(18, 26);
perch_angle_jitter = random_range(-15, 15); // небольшой разброс, чтобы не висела идеально сбоку
perch_side = -1; // -1 = слева от игрока, 1 = справа; стартует слева
perch_switch_margin = 10; // гистерезис, не переключается туда-сюда на самой границе
perch_offset_x = lengthdir_x(perch_dist, 180 + perch_angle_jitter);
perch_offset_y = lengthdir_y(perch_dist, 180 + perch_angle_jitter);

// лёгкое покачивание в стороны на месте
wander_phase_x = random(1000);
wander_phase_y = random(1000);
wander_speed_x = random_range(0.02, 0.035);
wander_speed_y = random_range(0.02, 0.035);
wander_amp = random_range(5, 9);

follow_lerp = 0.05; // с какой задержкой ворона подтягивается за игроком

// поле зрения, если враг заходит в этот радиус, ворона начинает в него биться
vision_radius = 45; // больше амплитуда, бьёт издалека, размах заметнее
charge_speed = 2.8; // чуть медленнее
return_speed = 1.6;
arrive_dist = 4; // насколько близко нужно долететь

state = "hover"; // hover -> charging -> returning -> hover
target_enemy = noone;

image_xscale = 1;
