// притягиваемся к центру двери
x = lerp(x, door_x, 0.12);
y = lerp(y, door_y, 0.12);

// крутимся вправо
angle -= spin_speed;

// уменьшаемся
xscale = lerp(xscale, 0, 0.03);
yscale = lerp(yscale, 0, 0.03);

// фейдимся
alpha = lerp(alpha, 0, 0.06);

//if (alpha < 0.05) {
//	// меняем комнату когда фейд завершён
//	if (instance_exists(FadeTransitionO) && FadeTransitionO.fade_done) {
//	    LevelControllerO.change_room();
//	    instance_destroy();
//	}
//}