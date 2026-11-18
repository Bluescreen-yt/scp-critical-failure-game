@icon("res://dev_textures/blue_bean.png") class_name Player extends RigidBody3D

@export_subgroup("permissions", "perm")
@export var perm_can_rotate := true ## can player rotate?
@export var perm_can_move := true ## can player move?
@export var perm_blinks := true ## should player blink?
@export var perm_health_enabled := true ## should player ignore health? ( god mode )
@export var perm_can_interact := true ## can player interact?
@export var perm_can_grab := true ## can player grab?

@export_subgroup("params", "param")
@export var param_speed := 5.0
@export_range(0.01, 5.0) var param_sensetivity := 0.25

@export_subgroup("requirements", "req")
@export var req_health : AdvancedHealthComponent
@export var req_camera_sway_effect : CameraEffectOffset
@export var req_camera_handheld_effect : CameraEffectShake
@export var req_blink : FloatCounterComponent
@export var req_blood_particles : GPUParticles3D
@export var req_blood_particles_material : StandardMaterial3D
@export var req_interaction_ray : RayCast3D

var player_look := Vector3.ZERO
var player_look_velocity := Vector3.ZERO
var player_look_velocity_multipler := 0.65


var wakeup_timer: SceneTreeTimer = null # timer for opening eyes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Global.player == null:
		Global.player = self
	else:
		printerr("ERROR: PLAYER ALREADY EXISTS!")
		self.queue_free()

func _exit_tree() -> void:
	Global.player = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_pressed("dev_console"): # TO DO LATER: REMOVE WHEN NOT NEEED
		req_health.damage(15, "Head")
		
	if perm_can_rotate: _handle_player_rotation()
	if perm_blinks: _handle_blinking(delta)
	
	
	if int(req_health.drain_per_second)>0:
		req_blood_particles.emitting = true
		req_blood_particles_material.albedo_color = req_health.drain_color
		req_blood_particles.amount = int(req_health.drain_per_second*5)
	else:
		req_blood_particles.emitting = false

func _physics_process(delta: float) -> void:
	_handle_movement(delta)

## handles player's movement
func _handle_movement(_delta: float) -> void:
	var moveVevtor :=  Vector3.ZERO
	moveVevtor.z -= Input.get_action_strength("mv_forward") - Input.get_action_strength("mv_backwards")
	moveVevtor.x -= Input.get_action_strength("mv_left") - Input.get_action_strength("mv_right")
	
	var moveDir : Vector3= $Y.transform.basis * moveVevtor
	moveDir *= param_speed
	
	var TargetVel :Vector3= moveDir-linear_velocity*0.9
	TargetVel = TargetVel * Vector3(1,0,1)
	apply_impulse(TargetVel)



## handles blinking
func _handle_blinking(delta: float) -> void:
	var new_blink :float = req_blink.value
	
	if not req_blink.below_threshold:
		new_blink -= delta*25
	else:
		new_blink = -.1
	
	if Input.is_action_pressed("blink"):
		new_blink = 0.
	
	if new_blink == -.1:
		if wakeup_timer==null:
			
			if not Global.is_player_blinking:
				Global.is_player_blinking = true
			
			wakeup_timer = get_tree().create_timer(.05)
			wakeup_timer.timeout.connect(func() -> void: req_blink.set_value(100), CONNECT_ONE_SHOT)
	else:
		if new_blink is float and new_blink==0:
			if not Global.is_player_blinking:
				Global.is_player_blinking = true
		
		if wakeup_timer!=null and wakeup_timer is SceneTreeTimer:
			wakeup_timer = null
			Global.is_player_blinking = false
		
		req_blink.set_value(new_blink)

## handles player's rotation
func _handle_player_rotation() -> void:
	player_look_velocity *= player_look_velocity_multipler
	
	req_camera_sway_effect.camera_offset.rotation_offset = player_look_velocity*.0015
	req_camera_sway_effect.camera_offset.rotation_offset.z += clampf(player_look_velocity.y*.0025, -45, 45)
	
	req_camera_handheld_effect.shake_speed_multipler = 1+((player_look_velocity.length()*2+linear_velocity.length())*2) + (1.-req_health.condition_percentage)*3.5
	req_camera_handheld_effect.shake_intesivity_multipler = .1+(1.-req_health.condition_percentage)
	
	%"Camera-origin".rotation_degrees.x = player_look.x
	$Y.rotation_degrees.y = player_look.y



func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		player_look.y -=  event.relative.x * param_sensetivity
		player_look.x -=  event.relative.y * param_sensetivity
		
		player_look_velocity.y -= event.relative.x * param_sensetivity
		player_look_velocity.x -=  event.relative.y * param_sensetivity
		
		player_look.x = clampf(player_look.x, -90, 90)
