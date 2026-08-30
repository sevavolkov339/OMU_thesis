owner = PlayerBallerO;

sprite_index = WingsDownS;
image_index = 0;
image_speed = 0;
image_xscale = 1;

// ready -> flying -> cooldown -> ready
fly_state = "ready";
flying = false;

fly_timer = 0;
fly_duration = room_speed * 5; // максимум 5 секунд полёта

cooldown_timer = 0;
cooldown_duration = room_speed * 3; // 3 секунды кулдауна
