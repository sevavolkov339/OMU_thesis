if (!instance_exists(owner)) exit;

// направление уже полностью определяется выбором кадра (image_index) в Step_0

draw_sprite_ext(SigarettS, image_index, owner.x, owner.y + owner.fly_visual_y, 1, 1, 0, c_white, owner.image_alpha);