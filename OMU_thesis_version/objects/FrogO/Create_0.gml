image_index = 0;
image_speed = 0;
croak_timer = irandom_range(90, 300); // рандомная задержка до первого кваканья

// в мире 2 лягушка одета в шарф
var _in_world_2 = instance_exists(GameControllerO) && string_pos("w2_", GameControllerO.world_stage) == 1;
if (_in_world_2) {
    sprite_index = BigFrogInScarfS;
}