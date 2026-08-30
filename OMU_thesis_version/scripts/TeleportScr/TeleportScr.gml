function TeleportScr(_target, _mode) {
    if (!instance_exists(_target)) exit;
    _target.teleporting = true;
    _target.teleport_timer = 0;
    _target.teleport_mode = _mode;
    _target.teleport_base_xscale = _target.image_xscale;
    _target.teleport_base_yscale = _target.image_yscale;
    _target.teleport_saved_angle = _target.image_angle; // сохраняем угол
    _target.teleport_white = (_mode == "in") ? 1 : 0;
    _target.image_alpha = (_mode == "in") ? 0 : 1;
    
	if (_mode == "in") {
	    _target.teleport_phase = 0;
	    _target.teleport_white = 1; // начинаем белым
	    _target.image_alpha = 0;
	    _target.image_xscale = _target.teleport_base_xscale * 0.05;
	    _target.image_yscale = _target.teleport_base_yscale * 8;
	} else {
        _target.teleport_phase = 0;
    }
}