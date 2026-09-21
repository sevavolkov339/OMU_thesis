//lifetime++;
//if (lifetime >= max_lifetime) {
//    instance_destroy();
//    exit;
//}
//wobble_timer += wobble_speed;
//x += hsp + sin(wobble_timer) * wobble_amp * 0.1;
//y -= vsp;
// замедляемся вверху
//vsp *= 0.995;
//radius = lerp(radius, radius + 0.02, 0.1);

wobble_timer += 0.06;
x += hsp + sin(wobble_timer) * 0.3;
y -= vsp;
// замедляемся по мере подъёма
vsp = lerp(vsp, 0, 0.015);
// уничтожаем если достигли максимальной высоты или анимация закончилась
if (y < start_y - max_height) {
    instance_destroy();
    exit;
}
if (image_index >= image_number - 1) {
    instance_destroy();
}