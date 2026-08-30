// физика
vel_x = random_range(-2, 2);
vel_y = random_range(-2, 2);
friction_spd = 0.99;

// дыхание squash stretch
float_timer = random(pi * 2);
bubble_scale_x = 1;
bubble_scale_y = 1;
bubble_scale_x_speed = 0;
bubble_scale_y_speed = 0;

// лопание
popped = false;
pop_timer = 0;

// айтем
item = noone;

// стены
wall = [WallO, WallTriangleO];

function pop() {
    if (popped) exit;
    popped = true;
    pop_timer = 0;
    // подбираем павер ап
    if (item != noone && instance_exists(PlayerBallerO)) {
        if (instance_exists(InventoryControllerO)) {
            InventoryControllerO.add_item(item);
        }
        audio_play_sound(StoreBuy_Snd, 0, false);
    }
}