emit_timer++;
if (emit_timer >= emit_interval) {
    emit_timer = 0;
    var _p = instance_create_layer(
        x + random_range(-4, 4),
        y + random_range(-2, 2),
        "EffectsL",
        FireSmokeParticleO
    );
}