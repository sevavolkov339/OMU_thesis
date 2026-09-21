// pause

if (GameControllerO.game_paused)
{
    alarm_set(0, 1); // проверяем позже
    exit;
}

// откинут шипами PuffFishO, не перехватываем путь обратно, пока это не закончится
if (puff_stunned) {
    alarm_set(0, 1);
    exit;
}

if instance_exists(PlayerBallerO){

	path_delete(path);
	path = path_add();

	// where to go
	target_x = PlayerBallerO.x
	target_y = PlayerBallerO.y

	// use grid and make the path
	mp_grid_path(SetupPathwayO.grid, path,x,y,target_x, target_y,1)

	path_start(path,0.5,path_action_stop,true)



	//alarm loop/ how often does the path update
	alarm_set(0,10);

}