if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}


x = owner.x;
y = owner.y;

//if (owner.speed > 0) {
//    blood_timer++;
//    if (blood_timer >= blood_interval) {
//        blood_timer = 0;
//		var _drop = instance_create_layer(x + random_range(-3, 3), y + random_range(-3, 3), "EffectsL", BloodDropO);
//		var _outline = instance_create_layer(_drop.x, _drop.y, "EffectsL", BloodDropOutlineO);
//        _outline.ref = _drop;
//        //_outline.r = _drop.r;
//    }
//}

blood_timer++;
if (blood_timer >= blood_interval) {
    blood_timer = 0;
	var _drop = instance_create_layer(x + random_range(-3, 3), y + random_range(-3, 3), "BloodL", BloodDropO);
	var _outline = instance_create_layer(_drop.x, _drop.y, "BloodUnderL", BloodDropOutlineO);
    _outline.ref = _drop;
    //_outline.r = _drop.r;
}


