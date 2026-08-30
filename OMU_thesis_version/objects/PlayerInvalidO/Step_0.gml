if speed > 0{
	speed -= 0.3	
}
else{
	speed = 0	
}


//normal collision
/*
//horizontal collision
if (place_meeting(x+hspeed,y,WallO)) {
	while(!place_meeting(x+sign(hspeed),y,WallO)){
		x += sign(hspeed)	
	}
	hspeed = 0
}

//vertical collision
if (place_meeting(x,y+vspeed,WallO)) {
	while(!place_meeting(x,y+sign(vspeed),WallO)){
		y += sign(vspeed)	
	}
	vspeed = 0
}
*/

if mouse_check_button(mb_left){
	if shootTimer == 0{
		speed = 7
		direction = TaggunO.image_angle - 180
		instance_create_layer(x,y,"BulletsL",BulletO)
		shootTimer = 10
	}
}

if shootTimer > 0{
	shootTimer --	
}

//sprite controll
if (x < mouse_x)        
{
	sprite_index = PlayerInvalidGoRightS; 
}
else
{
	sprite_index = PlayerInvalidGoLeftS	; 
}