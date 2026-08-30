// pause

paused = false;

saved_speed = 0;

saved_direction = 0;







//other

spin = 0

max_speed = 10;

spin_angle = 0;

visual_angle = 0;

spin_dir = choose(-1, 1);

spin_rate = 4;

spin_step = 30;

image_angle = 0;

idle_sprite = ShotgunS;

reload_sprite = ShotgunReloadS;

mask_index = idle_sprite;



reload_next = false;

anim_playing = false;

bounce_happened = false;

shotgun_bounce_cooldown = 0;

shotgun_bounce_cooldown_max = 18;

shotgun_kick_force = 2.5;

muzzle_dist = 22;



function shotgun_reset_idle() {

    sprite_index = idle_sprite;

    image_index = 0;

    image_speed = 0;

    anim_playing = false;

    mask_index = idle_sprite;

}



function shotgun_spawn_smoke(_mx, _my) {

    var _count = 4 + irandom(3);

    for (var i = 0; i < _count; i++) {

        instance_create_layer(_mx, _my, "EffectsL", ShotgunSmokeParticleO);

    }

}



function shotgun_eject_shell() {

    var _shell = instance_create_layer(x, y, "EffectsL", ShotgunShellO);

    _shell.direction = random(360);

    _shell.speed = random_range(3, 6);

}



function shotgun_fire() {

    FreezeScr(100);

    var _snd = audio_play_sound(ShotgunShootDistort_Snd, 1, false);
    audio_sound_pitch(_snd, random_range(0.85, 1.15));

    if (instance_exists(CameraControllerO)) {

        CameraControllerO.camera_shake(2, 15);

    }



    var _mx = x + lengthdir_x(muzzle_dist, visual_angle);

    var _my = y + lengthdir_y(muzzle_dist, visual_angle);



    var _shot = instance_create_layer(_mx, _my, "EffectsL", ShotgunShotO);

    _shot.image_angle = visual_angle;



    shotgun_spawn_smoke(_mx, _my - 4);

    shotgun_eject_shell();



    direction = (visual_angle + 180) mod 360;

    speed = clamp(speed + shotgun_kick_force, min_speed, max_speed);

}



function shotgun_on_bounce() {

    if (shotgun_bounce_cooldown > 0) return;



    shotgun_bounce_cooldown = shotgun_bounce_cooldown_max;

    spin_dir *= -1;

    if (reload_next) {
        audio_play_sound(ShotgunReload_Snd, 1, false);
        sprite_index = reload_sprite;
        image_index = 0;
        image_speed = 1;
        anim_playing = true;
        reload_next = false;
    } else {
        shotgun_fire();
        reload_next = true;
    }

}



function shotgun_update_anim() {

    if (!anim_playing || image_speed <= 0) return;

    if (floor(image_index) >= sprite_get_number(sprite_index) - 1) {

        shotgun_reset_idle();

    }

}



//wall = WallO

wall = [WallO, WallTriangleO]



// Начальные значения (можно изменить из другого объекта)

speed = 0;

direction = 0;



// Переменная для определения минимальной скорости

min_speed = 0.1;

// был ли уже засчитан удар о другой мяч (сбрасывается когда расходятся)

touching_bullet = false;

// короткое окно неуязвимости от повторного касания/отскока ИМЕННО от того же врага сразу после отскока
enemy_bounce_immune_id = noone;
enemy_bounce_immune_timer = 0;



// телепортация

teleporting = false;

teleport_timer = 0;

teleport_phase = 0;

teleport_base_xscale = image_xscale;

teleport_base_yscale = image_yscale;

teleport_white = 0;



//being held



held = false;

item_state = "free";



//trail



trail_timer = 0;

trail_interval = 10;



var _trail = instance_create_layer(x, y, "EffectsL", TrailEffectO);

_trail.parent_obj = id;



image_speed = 0;

