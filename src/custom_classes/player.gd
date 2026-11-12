@icon("res://dev_textures/blue_bean.png") class_name Player extends RigidBody3D

@export var speed := 5.0
@export var health : AdvancedHealthComponent
@export_range(0.01, 5.0) var sensetivity := 0.25
@export var camera_sway_effect : CameraEffectOffset
@export var camera_handheld_effect : CameraEffectShake
@export var blink : FConterComponent
@export var blood_particles : GPUParticles3D
@export var blood_particles_material : StandardMaterial3D

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
	
	if Input.is_action_just_pressed("dev_console"):
		health.damage(15, "Head")
		
	_handle_player_rotation()
	_handle_blinking(delta)
	
	if int(health.drain_per_second)>0:
		blood_particles.emitting = true
		blood_particles_material.albedo_color = health.drain_color
		blood_particles.amount = int(health.drain_per_second*5)
	else:
		blood_particles.emitting = false

func _physics_process(delta: float) -> void:
	_handle_movement(delta)

## handles player's movement
func _handle_movement(delta: float):
	var moveVevtor =  Vector3.ZERO
	moveVevtor.z -= Input.get_action_strength("mv_forward") - Input.get_action_strength("mv_backwards")
	moveVevtor.x -= Input.get_action_strength("mv_left") - Input.get_action_strength("mv_right")
	
	var moveDir = $Y.transform.basis * moveVevtor
	moveDir *= speed
	
	var TargetVel = moveDir-linear_velocity*0.9
	TargetVel = TargetVel * Vector3(1,0,1)
	apply_impulse(TargetVel)



## handles blinking
func _handle_blinking(delta: float):
	var new_blink = blink.value
	
	if not blink.below_threshold:
		new_blink -= delta*25
	else:
		new_blink = "wakey wakey"
	
	if Input.is_action_pressed("blink"):
		new_blink = 0.
	
	if new_blink is String and new_blink == "wakey wakey":
		if wakeup_timer==null:
			
			if not Global.is_player_blinking:
				Global.is_player_blinking = true
			
			wakeup_timer = get_tree().create_timer(.05)
			wakeup_timer.timeout.connect(func(): blink.set_value(100), CONNECT_ONE_SHOT)
	else:
		if new_blink is float and new_blink==0:
			if not Global.is_player_blinking:
				Global.is_player_blinking = true
		
		if wakeup_timer!=null and wakeup_timer is SceneTreeTimer:
			wakeup_timer = null
			Global.is_player_blinking = false
		
		blink.set_value(new_blink)

## handles player's rotation
func _handle_player_rotation():
	player_look_velocity *= player_look_velocity_multipler
	
	camera_sway_effect.camera_offset.rotation_offset = player_look_velocity*.0015
	camera_sway_effect.camera_offset.rotation_offset.z += clampf(player_look_velocity.y*.0025, -45, 45)
	
	camera_handheld_effect.shake_speed_multipler = 1+((player_look_velocity.length()*2+linear_velocity.length())*2) + (1.-health.condition_percentage)*3.5
	camera_handheld_effect.shake_intesivity_multipler = .5+(1.-health.condition_percentage)*3.5
	
	%"Camera-origin".rotation_degrees.x = player_look.x
	$Y.rotation_degrees.y = player_look.y



func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		player_look.y -=  event.relative.x * sensetivity
		player_look.x -=  event.relative.y * sensetivity
		
		player_look_velocity.y -= event.relative.x * sensetivity
		player_look_velocity.x -=  event.relative.y * sensetivity
		
		player_look.x = clampf(player_look.x, -90, 90)
