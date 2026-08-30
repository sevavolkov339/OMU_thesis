if (GameControllerO.game_paused) exit;

if (instance_exists(PlayerBallerO)) {
    var dist = distance_to_object(PlayerBallerO);
    if (dist < open_radius && !store_open) {
        store_open = true;
        generate_offers();
    } else if (dist >= open_radius && store_open) {
        store_open = false;
        with (ItemBubbleStoreO) instance_destroy();
    }
}