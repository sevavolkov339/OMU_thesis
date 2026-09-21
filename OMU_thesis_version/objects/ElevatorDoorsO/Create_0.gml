// размеры дверей
door_height = 10;
door_width  = 45;

// анимация
gap = 0;
max_gap = 40;
anim_speed = 0.1;

// состояния
state = 0; // 0 = closed, 1 = opening, 2 = open, 3 = closing

// цвет
door_color = c_white;

// флаги для ограничения одного открытия/закрытия
opened_once = false;
closed_once = false;

// дистанция триггера
open_distance = 40;
close_distance = 40;

// открыть двери вручную
function door_open()
{
    if (state == 0 && !opened_once)
    {
        state = 1;
    }
}

// закрыть двери вручную
function door_close()
{
    if (state == 2 && opened_once && !closed_once)
    {
        state = 3;
    }
}

// ориентация
is_vertical = false;