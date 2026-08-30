//// SnowStepEffectO рисуется в 3 слоя через depth: Layer1 (самый верхний) -> Layer2 -> Layer3 (самый нижний).
//// Один и тот же объект используется и как "верхний" слой, и как спавнер двух под-слоёв —
//// is_sub_layer (задаётся через struct в instance_create_layer ДО этого Create-события)
//// не даёт под-слоям бесконечно плодить ещё под-слои.
//if (!variable_instance_exists(id, "is_sub_layer")) {
//    is_sub_layer = false;
//}

//if (!is_sub_layer) {
//    sprite_index = SnowStepEffectLayer1S;
//    depth = 1000; // верхний слой — рисуется поверх остальных двух

//    instance_create_layer(x, y, "EffectsL", SnowStepEffectO, {
//        is_sub_layer: true,
//        sprite_index: SnowStepEffectLayer2S,
//        depth: 1100,
//        image_xscale: image_xscale,
//        image_yscale: image_yscale,
//        image_angle: image_angle
//    });

//    instance_create_layer(x, y, "EffectsL", SnowStepEffectO, {
//        is_sub_layer: true,
//        sprite_index: SnowStepEffectLayer3S,
//        depth: 1200, // нижний слой — рисуется под остальными двумя
//        image_xscale: image_xscale,
//        image_yscale: image_yscale,
//        image_angle: image_angle
//    });
//}

//image_speed = 0;
//image_alpha = 1;
