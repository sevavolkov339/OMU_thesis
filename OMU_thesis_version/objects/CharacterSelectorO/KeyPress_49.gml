// creating PlayerInvalid
if instance_exists(PlayerGurlO){
	instance_create_layer(PlayerGurlO.x,PlayerGurlO.y,"PlayerL",PlayerInvalidO)
	instance_create_layer(PlayerGurlO.x,PlayerGurlO.y,"TaggunL",TaggunO)
	instance_destroy(HammerO)
	instance_destroy(PlayerGurlO)
}

if instance_exists(PlayerBallerO){
	instance_create_layer(PlayerBallerO.x,PlayerBallerO.y,"PlayerL",PlayerInvalidO)
	instance_create_layer(PlayerBallerO.x,PlayerBallerO.y,"TaggunL",TaggunO)
	instance_destroy(PlayerBallerO)
	instance_destroy(BulletBounceO)
	instance_destroy(BallerHitAreaO)
}




