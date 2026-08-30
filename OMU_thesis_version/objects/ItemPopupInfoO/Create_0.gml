// массив частей текста, задаётся снаружи сразу после создания:
// [{ type: "text", value: "-1 " }, { type: "sprite", value: HealthS }, ...]
parts = [];

vy = -0.5;
lifetime = 90;
timer = 0;

layer = layer_get_id("DeadL");