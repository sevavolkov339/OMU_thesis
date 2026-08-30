if (GameControllerO.game_paused) exit;

phase_timer++;

switch (phase) {
    case "in":
        var _t = phase_timer / in_duration;
        _t = min(_t, 1);
        // ease out
        var _ease = 1 - power(1 - _t, 3);
        x = lerp(start_x, target_x, _ease);
        y = lerp(start_y, target_y, _ease);
        
        // объект следует за рукой
        if (instance_exists(carried_inst)) {
            carried_inst.x = x;
            carried_inst.y = y;
            // scale растёт по мере приближения
            carried_inst.image_xscale = _ease;
            carried_inst.image_yscale = _ease;
        }
        
        if (phase_timer >= in_duration) {
            phase = "place";
            phase_timer = 0;
            x = target_x;
            y = target_y;
            // финально кладём объект
            if (instance_exists(carried_inst)) {
                carried_inst.x = target_x;
                carried_inst.y = target_y;
                carried_inst.image_xscale = 1;
                carried_inst.image_yscale = 1;
                if (variable_instance_exists(carried_inst, "held")) carried_inst.held = false;
            }
        }
    break;

    case "place":
        // рука стоит на месте, небольшая пауза
        if (phase_timer >= place_duration) {
            phase = "out";
            phase_timer = 0;
            // объект больше не привязан к руке
            carried_inst = noone;
        }
    break;

    case "out":
        var _t = phase_timer / out_duration;
        _t = min(_t, 1);
        var _ease = power(_t, 2); // ease in
        x = lerp(target_x, start_x, _ease);
        y = lerp(target_y, start_y, _ease);
        
        if (phase_timer >= out_duration) {
            instance_destroy();
        }
    break;
}