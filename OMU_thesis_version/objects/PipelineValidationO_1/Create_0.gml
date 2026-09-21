// вся логика записи - в родителе PipelineValidationO
if (!object_is_ancestor(object_index, PipelineValidationO)) {
    show_message(object_get_name(object_index) + ": не задан Parent = PipelineValidationO, ничего не будет записано. Задай родителя в редакторе объекта.");
    exit;
}
event_inherited();
if (!instance_exists(id)) exit; // родитель нашёл второй логгер и убрал этот

cfg_name       = "C1";
cfg_pathfinder = "astar";
cfg_generator  = "bsp";
