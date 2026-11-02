@icon("res://dev_textures/blue_bean.png") class_name Player extends RigidBody3D

@export var speed := 5.0
@export var health : AdvancedHealthComponent
@export_range(0.01, 5.0) var sensetivity := 0.15
var _playerLook := Vector3.ZERO

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
	apply_impulse(TargetVel)
	
	if Input.is_action_just_pressed("interact"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	%Camera.rotation_degrees.x = _playerLook.x
	$Y.rotation_degrees.y = _playerLook.y


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_playerLook.y -=  event.relative.x * sensetivity
		_playerLook.x -=  event.relative.y * sensetivity
		
		_playerLook.x = clampf(_playerLook.x, -90, 90)
