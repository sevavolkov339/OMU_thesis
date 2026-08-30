global.gameWidth = 384;
global.gameHeight = 216;
global.windowWidth = 1280;
global.windowHeight = 720;
//global.windowWidth = 384;
//global.windowHeight = 216;
global.resolution = 1;

cam = view_camera[0];
//cam = camera_create()
//vm = matrix_build_lookat(0, 0, -10, 0, 0, 0, 0, 1, 0)
//pm = matrix_build_projection_ortho(global.gameWidth,global.gameHeight, 1, 3200)
view_w = camera_get_view_width(cam);
view_h = camera_get_view_height(cam);


// move
start_x = 0;
start_y = 0;
target_x = 0;
target_y = 0;

move_time = 0;
move_duration = 60;
moving = false;

// follow
follow_target = noone;
following = false;

//camera shake

clean_cam_x = 384;
clean_cam_y = 216;
cam_shake_timer = 0;
cam_shake_duration = 1;
cam_shake_strength = 0;


function camera_move_to_object(_obj)
{
    start_x = camera_get_view_x(cam);
    start_y = camera_get_view_y(cam);

    target_x = _obj.x - view_w * 0.5;
    target_y = _obj.y - view_h * 0.5;

    move_duration = room_speed * 0.5;
    move_time = 0;

    moving = true;
    following = false;
}


function camera_move_to_room_center()
{
	start_x = clean_cam_x;
	start_y = clean_cam_y;

    var room_cx = room_width  * 0.5;
    var room_cy = room_height * 0.5;

    target_x = room_cx - view_w * 0.5;
    target_y = room_cy - view_h * 0.5;

    move_duration = room_speed * 0.1; 
    move_time = 0;

    moving = true;
    following = false;
}


//camera follow

function camera_move_and_follow_object(_obj, _duration)
{
    if (!instance_exists(_obj)) return;

	start_x = clean_cam_x;
	start_y = clean_cam_y;

    target_x = _obj.x - view_w * 0.5;
    target_y = _obj.y - view_h * 0.5;

    move_time = 0;
    move_duration = max(1, _duration);
    moving = true;

    follow_target = _obj;
    following = false; // important
}


//camera shake

//cam_shake_timer = 0;
//cam_shake_timer = 0;
//cam_shake_duration = 1;
//cam_shake_strength = 0;

//function camera_shake(_strength, _duration) {
//    cam_shake_timer = _duration;
//    cam_shake_strength = _strength;
//}




function camera_shake(_strength, _duration) {
    cam_shake_duration = _duration;
    cam_shake_timer = _duration;
    cam_shake_strength = _strength;
}



surf = surface_create(global.gameWidth, global.gameHeight);

// pixel perfect surface
//pixel_surface = surface_create(view_w, view_h);

