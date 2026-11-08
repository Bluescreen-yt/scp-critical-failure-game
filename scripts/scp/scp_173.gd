extends RigidBody3D

var is_player_blinking = false

func _ready() -> void:
	Global.player_blink_changed.connect(
		func(val): 
			is_player_blinking = val
	) # update is_player_blinking

func _process(delta: float) -> void:
	var target_vel = Vector3()
	if Global.player != null: # if player exists
		$Player.target_position = $Player.to_local(Global.player.global_position)  # set raycast to player's position
		$Player.force_raycast_update()
		if ( not $VisibleOnScreenNotifier3D.is_on_screen() ) or is_player_blinking or not $Player.get_collider() is Player:
			self.look_at(Global.player.global_position)
			rotation.x = 0
			rotation.z = 0
			target_vel = self.transform.basis*Vector3(0,0,-100)
			
			if self.global_position.distance_to(Global.player.global_position)<2: # TO DO: rework this to work universaly for any enitty ( ignore scp group )
				Global.player.health.damage(9999, "Head")
		
	apply_impulse(target_vel-linear_velocity)
