vy += gravity;
x += vx;
y += vy;
lifetime++;

// анимация спрайта
image_index = (lifetime + anim_offset) mod image_number;

var fade_start = max_lifetime * 0.75;
if (lifetime > fade_start) {
    alpha = 1 - ((lifetime - fade_start) / (max_lifetime - fade_start));
} else {
    alpha = 1;
}

if (lifetime >= max_lifetime) instance_destroy();