follow_target = noone;

// ищем ближайший автомат при спавне
var _nearest_trade = instance_nearest(x, y, TradeMachineO);
var _nearest_slot = instance_nearest(x, y, SlotMachineO);

// выбираем ближайший из двух
if (_nearest_trade != noone && _nearest_slot != noone) {
    var _dist_trade = point_distance(x, y, _nearest_trade.x, _nearest_trade.y);
    var _dist_slot = point_distance(x, y, _nearest_slot.x, _nearest_slot.y);
    follow_target = (_dist_trade < _dist_slot) ? _nearest_trade : _nearest_slot;
} else if (_nearest_trade != noone) {
    follow_target = _nearest_trade;
} else if (_nearest_slot != noone) {
    follow_target = _nearest_slot;
}

mask_index = WallFollowMachineS;
