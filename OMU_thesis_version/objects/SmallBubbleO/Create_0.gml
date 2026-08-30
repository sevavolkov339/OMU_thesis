sprite_index = BubbleSmallS;
image_index = 0;
image_speed = 0;

rise_speed = random_range(0.4, 1.2);
bob_timer = random(360);
bob_speed = 0.05 + random(0.05);
bob_amp = 1.5 + random(1.5);
base_x = x;

// на какой высоте лопнет
pop_height = y - random_range(20, 60);
popped = false;