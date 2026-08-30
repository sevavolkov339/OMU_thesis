if (GameControllerO.game_paused)
{
    exit;
}



game_restart()

//reset everything

// Обновляем GameControllerO
if (instance_exists(GameControllerO)) {
	GameControllerO.player_hp = 3;
	GameControllerO.player_max_hp = 6;
	GameControllerO.player_money = 0;
}