//creating PlayerBaller
if instance_exists(PlayerGurlO){
	instance_create_layer(PlayerGurlO.x,PlayerGurlO.y,"PlayerL",PlayerBallerO)
	instance_create_layer(PlayerGurlO.x,PlayerGurlO.y,"BulletsL",BulletBounceO)
	instance_destroy(HammerO)
	instance_destroy(PlayerGurlO)
}

if instance_exists(PlayerInvalidO){
	instance_create_layer(PlayerInvalidO.x,PlayerInvalidO.y,"PlayerL",PlayerBallerO)
	instance_create_layer(PlayerInvalidO.x,PlayerInvalidO.y,"BulletsL",BulletBounceO)
	instance_destroy(PlayerInvalidO)
	instance_destroy(TaggunO)
}



