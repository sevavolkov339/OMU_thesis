depth = 10000;

//sprite_index = SpaceBackgroundS; 

// рандомный origin внутри спрайта
var _ox = irandom_range(50, 500); // x от 50 до 200
var _oy = irandom_range(50, 400); // y от 30 до 150
sprite_set_offset(sprite_index, _ox, _oy);

u_aspect = shader_get_uniform(SpaceShd, "u_aspect");