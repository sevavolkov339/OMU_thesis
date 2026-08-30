// pause
paused = false;
saved_speed = 0;
saved_direction = 0;



//other
spin = 0
max_speed = 10;

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

// ===== Ёж: раздутое / сдутое состояние =====
puff_inflated = false;

puff_deflate_delay = room_speed * 2; // сдувается, если столько кадров подряд не касалась врагов
puff_no_touch_timer = 0;

puff_radius = 40;     // радиус, в котором раскрытие шипов задевает врагов
puff_dmg = 1;         // урон врагам при раскрытии шипов

// отброс врагов: враги двигаются по пути (mp_grid_path), поэтому простое
// перемещение x/y тут же переписывается путём — вместо этого на время отброса
// останавливаем им путь (path_end) и разгоняем через speed/direction, гася
// скорость сами каждый кадр (враги не знают про этот механизм вообще)
puff_kb_force = 6;      // начальная скорость отброса (быстро улетают)
puff_kb_decay = 0.92;   // как быстро гаснет скорость отброса (меньше фрикция — дольше катятся)
puff_kb_duration = 20;  // сколько кадров вообще трогаем скорость врага, потом просто отпускаем
puff_kb_list = [];      // {eid, timer} — те, кого сейчас откидывает
puff_kb_wall = [WallO, WallTriangleO, WallForEnemiesO]; // от чего враги отскакивают во время отброса
puff_kb_boss_scale = 0.25; // босса откидывает значительно слабее, чем обычных врагов

sprite_deflated = sprite_index;  // обычный (сдутый) спрайт — как назначен в объекте
sprite_inflated = PuffyFishSpikesS; // спрайт с распущенными шипами и увеличенной маской
mask_deflated = sprite_deflated;
mask_inflated = sprite_inflated;

// движение зависит от состояния: сдутая — быстрее и с обычным фрикшном,
// раздутая — заметно медленнее и с большим фрикшном (быстрее теряет скорость)
friction_deflated = 0.98;
friction_inflated = 0.94;
puff_move_scale_deflated = 1;
puff_move_scale_inflated = 0.75;

sprite_index = sprite_deflated;
mask_index = mask_deflated;
image_angle = 0; // рыба никогда не крутится

// сквош-стретч анимация раздувания/сдувания (тот же приём, что и у кнопок меню)
squash_x = 1;
squash_y = 1;
squash_delay = 3;   // кадров между сплющиванием и растягиванием
squash_wait = -1;   // -1 = анимация не идёт

// откидывает одного конкретного врага (враги ходят по mp_grid_path, поэтому
// просто двигать x/y бесполезно — путь стопорим и разгоняем через speed/direction,
// гася скорость сами из PuffFishO.Step_0; враг потом сам вернётся к погоне)
puff_knock = function(_enemy_id, _force) {
    if (!instance_exists(_enemy_id)) return;
    var _dir = point_direction(x, y, _enemy_id.x, _enemy_id.y);
    var _actual_force = (_enemy_id.object_index == BossFlyO) ? _force * puff_kb_boss_scale : _force;
    with (_enemy_id) {
        path_end();
        direction = _dir;
        speed = _actual_force;
        shake_strength = 3;
        shake_timer = 10;
        puff_stunned = true; // отключает собственную логику движения врага на время отброса
    }
    array_push(puff_kb_list, { eid: _enemy_id, timer: puff_kb_duration });
}

puff_on = function() {
    puff_inflated = true;
    sprite_index = sprite_inflated;
    mask_index = mask_inflated;
    puff_no_touch_timer = 0;

    squash_x = 1.5;
    squash_y = 0.5;
    squash_wait = squash_delay;

    audio_play_sound(Enemy_Hit_Snd, 0, false);
    with (EnemyO) {
        if (point_distance(x, y, other.x, other.y) <= other.puff_radius) {
            hp -= other.puff_dmg;
            var _dmg_popup = instance_create_layer(x, y - 20, "DeadL", DamageO);
            _dmg_popup.dmg = other.puff_dmg;
            other.puff_knock(id, other.puff_kb_force);
        }
    }
}

puff_off = function() {
    puff_inflated = false;
    sprite_index = sprite_deflated;
    mask_index = mask_deflated;

    squash_x = 1.5;
    squash_y = 0.5;
    squash_wait = squash_delay;
}
