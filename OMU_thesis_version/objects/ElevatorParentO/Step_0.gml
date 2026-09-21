
// pause

if (GameControllerO.game_paused) exit;


if (!instance_exists(PlayerBallerO)) exit;
if (!instance_exists(LevelControllerO)) exit;
//if (used) exit;

// visibility
var can_be_visible =
    LevelControllerO.level_completed
    && !used
    && place_meeting(x, y, PlayerBallerO);

if (can_be_visible)
{
    image_alpha = min(image_alpha + 0.1, 1);
}
else
{
    image_alpha = max(image_alpha - 0.1, 0);
}

// enter cutscene
if (!LevelControllerO.level_completed) exit;
if (used) exit;

if (place_meeting(x, y, PlayerBallerO))
{
    if (!player_inside)
    {
        player_inside = true;

        var cs = enter_cutscene;
        show_debug_message("START CUTSCENE: " + cs);

        with (PlayerBallerO)
        {
            start_cutscene(cs);
        }
    }
}
else
{
    player_inside = false;
}


