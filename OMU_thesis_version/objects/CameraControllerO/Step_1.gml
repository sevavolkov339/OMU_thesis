//if (!view_enabled){
//	view_set_wport(0,global.gameWidth);	
//	view_set_hport(0,global.gameHeight);	
//	view_set_visible(0,true);
//	camera_set_view_mat(cam, vm);
//	camera_set_proj_mat(0, pm);
//	view_camera[0] = cam;
//	view_enabled = true;
//}

//if (window_get_width() != global.gameWidth * global.zoom 
//and window_get_height()!= global.gameHeight * global.zoom){
//	window_set_size(global.gameWidth*global.zoom, global.gameHeight*global.zoom);	
//	surface_resize(application_surface,global.gameWidth*global.resolution, global.gameHeight*global.resolution);
//	display_set_gui_size(global.gameWidth, global.gameHeight);
//}



if (window_get_width() != global.windowWidth
or window_get_height() != global.windowHeight) {
    window_set_size(global.windowWidth, global.windowHeight);
    surface_resize(application_surface, global.gameWidth, global.gameHeight);
    display_set_gui_size(global.gameWidth, global.gameHeight);
    
    // центрируем окно на экране
    var screen_w = display_get_width();
    var screen_h = display_get_height();
    window_set_position(
        (screen_w - global.windowWidth) / 2,
        (screen_h - global.windowHeight) / 2
    );
}

