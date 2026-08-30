// вызывается врагом на себе (self = враг). Возвращает true, только если враг сейчас
// перекрывается с ХОТЯ БЫ ОДНИМ реально ДВИЖУЩИМСЯ предметом (BulletBounceO или YoYoO).
// Статичный предмет (например, мяч уже остановился и просто лежит на враге) не считается —
// иначе touching_ball никогда не сбросится обратно в false, пока предмет не уберётся,
// и враг станет невосприимчив к урону от любых новых ударов.
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
