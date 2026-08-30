vy += gravity;
x += vx;
y += vy;
lifetime++;

var fade_start = max_lifetime * 0.6;
if (fade_delay > 0) {
    fade_delay--;
    alpha = 1;
} else if (lifetime > fade_start) {
    alpha = 1 - ((lifetime - fade_start) / (max_lifetime - fade_start));
} else {
    alpha = 1;
}

if (lifetime >= max_lifetime) instance_destroy();