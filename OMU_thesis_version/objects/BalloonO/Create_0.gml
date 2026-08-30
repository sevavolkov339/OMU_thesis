//owner = PlayerBallerO;

//// физика шарика
//vel_x = 0;
//vel_y = -1;
//rope_length = 45;        // длина нитки
//spring_strength = 0.06;  // жёсткость пружины к позиции покоя
//damping = 0.88;          // затухание скорости

//// стартовая позиция — прямо над игроком
//if (instance_exists(owner)) {
//    x = owner.x;
//    y = owner.y - rope_length;
//}

//image_angle = 0;

//// защита от урона
//hits_absorbed = 0; // сколько ударов уже поглотил
//max_absorb = 2;    // первые 2 удара без урона, 3-й = взрыв и пропадает

//function try_absorb_damage() {
//    // визуальный толчок шарика при ударе
//    vel_x += random_range(-5, 5);
//    vel_y += random_range(-6, -2);
    
//    hits_absorbed++;
    
//    if (hits_absorbed > max_absorb) {
//        pop_balloon();
//    }
//    return true; // всегда поглощает урон
//}

//function pop_balloon() {
//    // взрыв в позиции шарика
//    instance_create_layer(x, y, "EffectsL", ExplosionBombEffectO);
//    // удаляем из инвентаря
//    if (instance_exists(InventoryControllerO)) {
//        InventoryControllerO.remove_item("Balloon");
//    }
//    instance_destroy();
//}

owner = PlayerBallerO;

vel_x = 0;
vel_y = -1;
rope_length = 45;

// флоат — шарик покачивается вверх-вниз
float_timer = random(pi * 2);
float_speed = 0.03;
float_amplitude = 6;

// жёсткость очень мягкая — сильный delay
spring_strength = 0.018;
damping = 0.92;

// target позиция с запаздыванием
target_x = 0;
target_y = 0;
if (instance_exists(owner)) {
    x = owner.x;
    y = owner.y - rope_length;
    target_x = owner.x;
    target_y = owner.y;
}

image_angle = 0;
// восстанавливаем количество уже поглощённых ударов (сохраняется между комнатами)
hits_absorbed = instance_exists(GameControllerO) ? GameControllerO.saved_balloon_hits : 0;
max_absorb = 2;

function try_absorb_damage() {
    vel_x += random_range(-5, 5);
    vel_y += random_range(-8, -3);
    hits_absorbed++;
    if (instance_exists(GameControllerO)) {
        GameControllerO.saved_balloon_hits = hits_absorbed;
    }
    if (hits_absorbed > max_absorb) {
        pop_balloon();
    }
    return true;
}

function pop_balloon() {
    instance_create_layer(x, y, "EffectsL", ExplosionBombEffectO);
    if (instance_exists(GameControllerO)) {
        GameControllerO.saved_balloon_hits = 0;
    }
    if (instance_exists(InventoryControllerO)) {
        InventoryControllerO.remove_item("Balloon");
    }
    instance_destroy();
}