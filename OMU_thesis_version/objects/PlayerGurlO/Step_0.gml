// input
rightKey = keyboard_check(vk_right) or keyboard_check(ord("D"))
leftKey = keyboard_check(vk_left) or keyboard_check(ord("A"))
upKey = keyboard_check(vk_up) or keyboard_check(ord("W"))
downKey = keyboard_check(vk_down) or keyboard_check(ord("S"))

// movement
hspeed = (rightKey - leftKey) * moveSpd
vspeed = (downKey - upKey) * moveSpd





if speed > 0{
	speed -= 0.3	
}
else{
	speed = 0	
}

// horizontal collision
if (place_meeting(x+hspeed,y,WallO)) {
	while(!place_meeting(x+sign(hspeed),y,WallO)){
		x += sign(hspeed)	
	}
	hspeed = 0
}

// vertical collision
if (place_meeting(x,y+vspeed,WallO)) {
	while(!place_meeting(x,y+sign(vspeed),WallO)){
		y += sign(vspeed)	
	}
	vspeed = 0
}

// hammer

if mouse_check_button_pressed(mb_left) and stunAfterHammerTimer == 0{
	if sprite_index == PlayerGurlGoRightS and image_xscale == 1{
		sprite_index = PlayerGurlHammerRightS
		alarm_set(0,40)
	}
	if sprite_index == PlayerGurlGoRightS and image_xscale == -1{
		sprite_index = PlayerGurlHammerRightS
		image_xscale = -1
		alarm_set(0,40)
	}
	if sprite_index == PlayerGurlGoUpS{
		sprite_index = PlayerGurlHammerUpS
		alarm_set(0,40)
	}
	if sprite_index == PlayerGurlGoDownS{
		sprite_index = PlayerGurlHammerDownS
		alarm_set(0,40)
	}
	stunAfterHammerTimer = 80

}

if stunAfterHammerTimer > 0{
	stunAfterHammerTimer --	
	speed = 0
}

// sprite controll

if stunAfterHammerTimer == 0{

	if rightKey{
		sprite_index = PlayerGurlGoRightS
		image_xscale = 1
	}
	if leftKey{
		sprite_index = PlayerGurlGoRightS
		image_xscale = -1
	}
	if downKey{
		image_xscale = 1
		sprite_index = PlayerGurlGoDownS	
	}
	if upKey{
		image_xscale = 1
		sprite_index = PlayerGurlGoUpS
	}

}


