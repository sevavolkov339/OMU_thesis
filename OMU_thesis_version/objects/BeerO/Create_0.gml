// BeerO — чисто визуальный компаньон, следует за игроком, сам урон не наносит.
// Сам эффект (двойной урон от предметов + инверсия управления) обрабатывается централизованно
// через InventoryControllerO.has_item("Beer") в GameControllerO/PlayerBallerO.
owner = PlayerBallerO;
float_timer = random(1000);
