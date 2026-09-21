// нельзя предлагать/давать игроку предмет, которого у него уже достаточно
function IsItemMaxedOutScr(_name) {
    if (!instance_exists(InventoryControllerO)) return false;
    if (_name == "Placeholder 1") return false;
    if (_name == "Birdie") return InventoryControllerO.count_item("Birdie") >= 3;
    return InventoryControllerO.has_item(_name);
}
