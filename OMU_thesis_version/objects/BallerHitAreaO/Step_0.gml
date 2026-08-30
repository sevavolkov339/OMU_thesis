

//pause

if (GameControllerO.game_paused) exit;

if instance_exists(PlayerBallerO){
	x = PlayerBallerO.x
	y = PlayerBallerO.y
	
	if instance_exists(BallTrajectoryO){

		if place_meeting(x,y,BulletBounceO){
			if global.alphadinamic < 1{
				global.alphadinamic += 0.1	
			}
		}
		else{
			if global.alphadinamic > 0{
				global.alphadinamic -= 0.1	
			}
		}
	}
}