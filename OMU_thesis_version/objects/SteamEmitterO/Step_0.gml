//emit_timer++;
//if (emit_timer >= emit_interval) {
//    emit_timer = 0;
//    var _p = instance_create_layer(
//        x + random_range(-emit_width, emit_width),
//        y,
//        "HandsL",
//        SteamParticleO
//    );
//}

emit_timer++;
if (emit_timer >= emit_interval) {
    emit_timer = 0;
    var _p = instance_create_layer(
        x + random_range(-emit_width, emit_width),
        y,
        "EnemyBulletsL",
        SteamParticleO
    );
    // иногда спавним бабл
    if (irandom(6) == 0) { // шанс 1 из 4
        instance_create_layer(
            x + random_range(-emit_width, emit_width),
            y,
            "EnemyBulletsL",
            SmallBubbleO
        );
    }
}