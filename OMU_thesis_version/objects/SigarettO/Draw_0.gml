if (!instance_exists(owner)) exit;

// направление уже полностью определяется выбором кадра (image_index) в Step_0 — сами кадры
// нарисованы смотрящими в нужную сторону, поэтому здесь больше не переворачиваем через xscale
// (раньше это применяло owner.image_xscale поверх уже выбранного кадра и всё портило)

// прозрачность повторяет игрока — исчезает/появляется вместе с ним при падении за пределы уровня
draw_sprite_ext(SigarettS, image_index, owner.x, owner.y + owner.fly_visual_y, 1, 1, 0, c_white, owner.image_alpha);