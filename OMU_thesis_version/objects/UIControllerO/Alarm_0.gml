//GameControllerO.toggle_pause(); // снимаем паузу перед уходом в меню
//GameControllerO.reset_run();
//room_goto(Main_Menu_Room);

GameControllerO.save_game();
GameControllerO.toggle_pause();
GameControllerO.level_music_suppressed = true;
GameControllerO.music_stop();
room_goto(Main_Menu_Room);