// нельзя предлагать/давать игроку предмет, которого у него уже достаточно —
// кроме Birdie (можно иметь до 3х) и Placeholder 1 (чистый заполнитель, не подчиняется правилу)
function IsItemMaxedOutScr(_name) {
    if (!instance_exists(InventoryControllerO)) return false;
    if (_name == "Placeholder 1") return false;
    if (_name == "Birdie") return InventoryControllerO.count_item("Birdie") >= 3;
    return InventoryControllerO.has_item(_name);
}
