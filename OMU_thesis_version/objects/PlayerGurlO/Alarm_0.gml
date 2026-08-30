if sprite_index == PlayerGurlHammerRightS and image_xscale == 1{
	instance_create_layer(x+55,y,"CodingStuffL",HammerHitAreaO)	
}

if sprite_index == PlayerGurlHammerRightS and image_xscale == -1{
	instance_create_layer(x-55,y,"CodingStuffL",HammerHitAreaO)	
}

if sprite_index == PlayerGurlHammerUpS{
	instance_create_layer(x,y-55,"CodingStuffL",HammerHitAreaO)	
}

if sprite_index == PlayerGurlHammerDownS{
	instance_create_layer(x,y+55,"CodingStuffL",HammerHitAreaO)	
}