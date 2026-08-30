// dmg переопределяется сразу после instance_create_layer тем, кто наносит урон
dmg = 1;
text_color = c_white;

vy = -0.6;
lifetime = 45;
timer = 0;

wave_timer = random(1000);

layer = layer_get_id("DeadL");
