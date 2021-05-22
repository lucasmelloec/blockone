extends KinematicBody


export var max_speed := 5
export var jump_impulse := 5
export var mouse_sensitivity := 0.01

enum Cameras {FIRST_PERSON_CAMERA, THIRD_PERSON_CAMERA, FRONTAL_CAMERA}
const cam_clamp := {
	Cameras.FIRST_PERSON_CAMERA: {"min": -89, "max": 89},
	Cameras.THIRD_PERSON_CAMERA: {"min": -60, "max": 18},
	Cameras.FRONTAL_CAMERA: {"min": -10, "max": 60},
}
const GRAVITY := Vector3.DOWN * 10

var velocity := Vector3()
var direction := Vector3()
var current_camera_id: int = Cameras.FIRST_PERSON_CAMERA
var current_cam_clamp : Dictionary = cam_clamp[Cameras.FIRST_PERSON_CAMERA]
var flying := true
var double_tap := {
	"action": "",
	"last_pressed": 0,
	"interval": 500,
}

onready var head := $Head
onready var camera := $Head/Camera


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	_process_input()
	_process_movement(delta)


func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg2rad(current_cam_clamp["min"]), deg2rad(current_cam_clamp["max"]))
		self.rotate_y(-event.relative.x * mouse_sensitivity)

		var camera_rot = head.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		head.rotation_degrees = camera_rot
	elif event.is_action_pressed("next_camera"):
		current_camera_id += 1
		current_camera_id %= Cameras.size()
		
		get_viewport().get_camera().clear_current(false)
		match current_camera_id:
			Cameras.FIRST_PERSON_CAMERA:
				camera.make_current()
				current_cam_clamp = cam_clamp[Cameras.FIRST_PERSON_CAMERA]
			Cameras.THIRD_PERSON_CAMERA:
				$Head/ThirdPersonCamera.make_current()
				current_cam_clamp = cam_clamp[Cameras.THIRD_PERSON_CAMERA]
			Cameras.FRONTAL_CAMERA:
				$Head/FrontalCamera.make_current()
				current_cam_clamp = cam_clamp[Cameras.FRONTAL_CAMERA]
		head.rotation.x = clamp(head.rotation.x, deg2rad(current_cam_clamp["min"]), deg2rad(current_cam_clamp["max"]))


func _process_input():
	direction = Vector3.ZERO
	
	var cam_basis = camera.get_global_transform().basis
	
	if Input.is_action_pressed("move_forward"):
		direction += -cam_basis.z
	if Input.is_action_pressed("move_backward"):
		direction += cam_basis.z
	if Input.is_action_pressed("move_right"):
		direction += cam_basis.x
	if Input.is_action_pressed("move_left"):
		direction += -cam_basis.x
	
	direction.y = 0
	direction = direction.normalized()
	
	if Input.is_action_just_pressed("jump"):
		if (double_tap["action"] == "jump"
				and OS.get_system_time_msecs() - double_tap["last_pressed"] <= double_tap["interval"]):
			flying = true
			double_tap["last_pressed"] = 0
		else:
			double_tap["action"] = "jump"
			double_tap["last_pressed"] = OS.get_system_time_msecs()
	
	if Input.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_impulse
		elif flying:
			direction.y = 1
	
	if Input.is_action_just_pressed("crouch"):
		if (double_tap["action"] == "crouch"
				and OS.get_system_time_msecs() - double_tap["last_pressed"] <= double_tap["interval"]):
			flying = false
			double_tap["last_pressed"] = 0
		else:
			double_tap["action"] = "crouch"
			double_tap["last_pressed"] = OS.get_system_time_msecs()
	
	if Input.is_action_pressed("crouch"):
		direction.y = -1
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process_movement(delta):
	velocity.x = direction.x * max_speed
	velocity.z = direction.z * max_speed
	
	if is_on_floor():
		flying = false
	
	if flying:
		velocity.y = direction.y * max_speed
	else:
		velocity += delta * GRAVITY
	
	velocity = move_and_slide(velocity, Vector3.UP)
