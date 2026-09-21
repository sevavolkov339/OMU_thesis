// вызывается врагом на себе (self = враг)
function EnemyTouchingMovingBulletScr() {
    var _min_speed = 0.5;
    var _touching = false;

    with (BulletBounceO) {
        if (speed > _min_speed && place_meeting(x, y, other.id)) {
            _touching = true;
        }
    }

    if (!_touching) {
        with (YoYoO) {
            var _spd = point_distance(0, 0, vel_x, vel_y);
            if (_spd > _min_speed && place_meeting(x, y, other.id)) {
                _touching = true;
            }
        }
    }

    return _touching;
}
