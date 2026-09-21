// creating PlayerGurl
if instance_exists(PlayerBallerO){
	instance_create_layer(PlayerBallerO.x,PlayerBallerO.y,"PlayerL",PlayerGurlO)
	instance_destroy(PlayerBallerO)
	instance_destroy(BulletBounceO)
	instance_destroy(BallerHitAreaO)
}

if instance_exists(PlayerInvalidO){
	instance_create_layer(PlayerInvalidO.x,PlayerInvalidO.y,"PlayerL",PlayerGurlO)
	instance_destroy(PlayerInvalidO)
	instance_destroy(TaggunO)
}


