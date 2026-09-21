if (!instance_exists(owner)) exit;

// позиция и спрайт крыльев ставятся прямо здесь
sprite_index = WingsUpS;

// игрок вылетел за пределы уровня и падает
var _falling = (owner.state == PlayerState.CUTSCENE && owner.cutscene_name == "WingsFall");
if (_falling) {
    image_xscale = owner.image_xscale;
    image_yscale = owner.image_yscale;
    image_angle = owner.image_angle;
} else {
    image_xscale = (owner.facing == "left") ? -1 : 1;
    image_yscale = 1;
    image_angle = 0;
}

x = owner.x;
y = owner.y + owner.fly_visual_y;
image_alpha = owner.image_alpha;

draw_self();
