//switch (phase) {
// case "grow"
//        var _dx = scale_target - scale_x;
//        var _dy = scale_target - scale_y;
        
//        scale_vx += _dx * stiffness;
//        scale_vy += _dy * stiffness;
//        scale_vx *= damping;
//        scale_vy *= damping;
//        scale_x += scale_vx;
//        scale_y += scale_vy;
        
// squash & stretch: противофаза
//        var _avg = (scale_x + scale_y) * 0.5;
//        scale_x = lerp(scale_x, _avg, 0.15);
//        scale_y = lerp(scale_y, _avg, 0.15);
// небольшое искажение пружины
//        scale_x += scale_vy * 0.08;
//        scale_y -= scale_vx * 0.08;
        
// цвет: жёлтый -> белый по мере роста
//        var _t = clamp(scale_x / scale_target, 0, 1);
//        col_b = _t; // синий канал 0->1 (жёлтый -> белый)
        
//        timer++;
//        if (timer > 20 && abs(scale_vx) < 0.04 && abs(scale_vy) < 0.04) {
//            phase = "blink";
//            scale_x = scale_target;
//            scale_y = scale_target;
//            col_b = 1.0;
//            blink_timer = 0;
//        }
//    break;

// case "blink"
//        blink_timer++;
//        var _progress = blink_timer / blink_duration; // 0..1
        
// частота мигания нарастает
//        var _freq = lerp(2.0, 18.0, _progress);
//        blink_visible = (sin(blink_timer * _freq * 0.2) > 0);
        
// общий альфа тоже падает к концу
//        alpha = 1.0 - _progress * 0.7;
        
//        if (blink_timer >= blink_duration) {
//            instance_destroy();
//        }
//    break;
//}