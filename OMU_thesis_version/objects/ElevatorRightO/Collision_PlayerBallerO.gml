if (!camera_triggered and LevelControllerO.level_completed and !used)
{
    camera_triggered = true;

    if (instance_exists(CameraControllerO))
    {
        with (CameraControllerO)
        {
            //camera_move_to_object(other);
			camera_move_and_follow_object(other,20);
        }
    }
}

