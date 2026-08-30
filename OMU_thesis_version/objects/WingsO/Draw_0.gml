if (!instance_exists(owner)) exit;

// позиция и спрайт крыльев ставятся прямо здесь, в Draw — Draw всегда выполняется уже после
// того как игрок обновил свои x/y в этом кадре, поэтому крылья садятся точно на него без
// кадра задержки, как будто они реально часть его спрайта
sprite_index = WingsUpS;

// игрок вылетел за пределы уровня и падает — крылья повторяют его вращение/сжатие/исчезновение 1-в-1,
// а не просто следуют за позицией, как обычно
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
