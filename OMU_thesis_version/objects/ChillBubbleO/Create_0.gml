sprite_index = ItemBubbleS;
image_index = 0;
image_speed = 0;
popped = false;

rise_speed = random_range(0.3, 0.7);
bob_timer = random(360);
bob_speed = 0.06 + random(0.04);
bob_amp = 1.2 + random(0.8);
base_x = x; // запоминаем стартовую позицию

pop_sound_played = false;