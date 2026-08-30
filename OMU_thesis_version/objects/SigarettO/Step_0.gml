if (GameControllerO.game_paused) exit;

if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

x = owner.x;
y = owner.y + owner.fly_visual_y; // поднимается вместе с игроком во время полёта на крыльях

// во время удара — кадр по стороне удара (kick_facing_right — отдельная, ничем кроме
// самого удара не перезаписываемая переменная), а не по facing. Плавание в воде (в том числе
// сценарное — например заплыв к горячему источнику) двигает игрока напрямую через x/y и меняет
// sprite_index без участия facing/speed, поэтому для воды проверяем sprite_index напрямую.
// Во всех остальных случаях, пока игрок реально движется — кадр по направлению взгляда (facing),
// одинаково и при ходьбе, и в полёте. А как только останавливается (айдл) — facing сам по себе
// не сбрасывается, поэтому явно возвращаем кадр "вниз" здесь, как у самого игрока
if (owner.sprite_index == PlayerBallerKickS) {
    image_index = owner.kick_facing_right ? 2 : 3;
} else if (owner.sprite_index == PlayerBallerGoRightInWaterS) {
    image_index = 2;
} else if (owner.sprite_index == PlayerBallerGoLeftInWaterS) {
    image_index = 3;
} else if (owner.sprite_index == PlayerBallerGoUpInWaterS) {
    image_index = 1;
} else if (owner.sprite_index == PlayerBallerGoDownInWaterS) {
    image_index = 0;
} else if (owner.speed > owner.minSpd) {
    switch (owner.facing) {
        case "right": image_index = 2; break; // 3й кадр
        case "left":  image_index = 3; break; // 4й кадр
        case "up":    image_index = 1; break; // 2й кадр
        default:      image_index = 0; break; // вниз
    }
} else {
    image_index = 0; // айдл — всегда вниз
}
image_speed = 0;

// дым
emit_timer++;
if (emit_timer >= emit_interval) {
    emit_timer = 0;
    var _p = instance_create_layer(
        x + random_range(-2, 2),
        y + random_range(-2, 2),
        "UIL",
        SigarettSmokeParticleO
    );
}