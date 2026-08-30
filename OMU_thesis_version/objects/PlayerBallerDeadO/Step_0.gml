switch (state) {
    case "shake":
        shake_timer++;
        var _t = shake_timer / shake_duration;
        var _shake_amt = lerp(5, 0, _t);
        x += random_range(-_shake_amt, _shake_amt);
        y += random_range(-_shake_amt, _shake_amt);
        if (shake_timer >= shake_duration) {
            state = "shrink";
        }
    break;

    case "shrink":
        shrink_timer++;
        var _t = shrink_timer / shrink_duration;
        image_xscale = lerp(1, 0, _t);
        image_yscale = lerp(1, 0, _t);
        alpha = lerp(1, 0, _t);
        //if (shrink_timer >= shrink_duration) {
        //    instance_destroy();
        //}
    break;
}

if (keyboard_check(ord("R"))) {
    room_restart();
}