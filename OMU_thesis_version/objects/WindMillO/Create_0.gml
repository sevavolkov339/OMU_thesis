// вращение лопастей (BigMill_MillS) по часовой стрелке с эффектом малого числа кадров, как у ShotgunO
mill_spin_angle = 0;
mill_spin_speed = 2;   // скорость вращения лопастей
mill_spin_step = 15;   // шаг в градусах — покадровый эффект вместо плавного вращения
mill_visual_angle = 0;


layer = layer_get_id("HandsL");

// силуэт игрока, когда он скрыт за мельницей (рисуется в Draw GUI, поэтому виден всегда поверх всего)
player_behind_mill = false;
silhouette_surf = -1;
silhouette_origin_x = 0;
silhouette_origin_y = 0;