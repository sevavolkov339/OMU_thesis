function ShakeScr(_target, _strength, _duration_sec) {
    if (!instance_exists(_target)) exit;
    var _duration = _duration_sec * room_speed;
    _target.shake_strength = _strength;
    _target.shake_duration = _duration;
    _target.shake_timer = _duration;
    _target.shake_offset_x = 0;
    _target.shake_offset_y = 0;
}