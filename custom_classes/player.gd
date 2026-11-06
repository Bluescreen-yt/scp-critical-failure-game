@icon("res://dev_textures/blue_bean.png") class_name Player extends RigidBody3D

@export var speed := 5.0
@export var health : AdvancedHealthComponent
@export_range(0.01, 5.0) var sensetivity := 0.25
@export var camera_sway_effect : CameraEffectOffset

var player_look := Vector3.ZERO
var player_look_velocity := Vector3.ZERO
var player_look_velocity_multipler := 0.65


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var moveVevtor =  Vector3.ZERO
	moveVevtor.z -= Input.get_action_strength("mv_forward") - Input.get_action_strength("mv_backwards")
	moveVevtor.x -= Input.get_action_strength("mv_left") - Input.get_action_strength("mv_right")
	
	var moveDir = $Y.transform.basis * moveVevtor
	moveDir *= speed
	
	var TargetVel = moveDir-linear_velocity*0.9
	TargetVel = TargetVel * Vector3(1,0,1)
	apply_impulse(TargetVel)
	
	if Input.is_action_just_pressed("interact"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	
	_handle_player_rotation()


func _handle_player_rotation():
	player_look_velocity *= player_look_velocity_multipler
	
	camera_sway_effect.camera_offset.rotation_offset = player_look_velocity*.0015
	camera_sway_effect.camera_offset.rotation_offset.z += clampf(player_look_velocity.y*.0025, -45, 45)
	
	%"Camera-origin".rotation_degrees.x = player_look.x
	$Y.rotation_degrees.y = player_look.y



func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player_look.y -=  event.relative.x * sensetivity
		player_look.x -=  event.relative.y * sensetivity
		
		player_look_velocity.y -= event.relative.x * sensetivity
		player_look_velocity.x -=  event.relative.y * sensetivity
		
		player_look.x = clampf(player_look.x, -90, 90)
