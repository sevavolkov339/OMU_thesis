if (instance_exists(PlayerBallerDeadO))
{
    visible = true;
    alpha = min(alpha + fade_speed, 1);
}
else
{
    alpha = 0;
    visible = false;
}