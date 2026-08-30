if (!instance_exists(PlayerBallerO)) exit;
x = PlayerBallerO.x;
y = PlayerBallerO.y;
if (instance_exists(held_item)) {
    held_item.x = PlayerBallerO.x;
    held_item.y = PlayerBallerO.y;
}