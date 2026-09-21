if (flash_active) {
    flash_timer++;
    var _progress = flash_timer / flash_duration; // 0..1
    
    // интервал мигания уменьшается, становится быстрее
    var _current_interval = max(1, floor(lerp(6, 1, _progress)));
    
    blink_timer++;
    if (blink_timer >= _current_interval) {
        blink_timer = 0;
        blink_visible = !blink_visible;
    }
    
    // альфа затухает со временем но в начале отчётливо
    flash_alpha = 1 //(1 - _progress) * 0.5;
    
    if (flash_timer >= flash_duration) {
        flash_active = false;
        flash_timer = 0;
        blink_visible = false;
        flash_alpha = 0;
    }
}