extends CharacterBody3D

# الثوابت
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003
const GROUND_DRAG = 0.1

# المتغيرات
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# ربط العقد
@onready var head = $head
@onready var camera = $head/Camera3D
@onready var raycast = $head/Camera3D/RayCast3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# معالجة الإدخالات
func _unhandled_input(event: InputEvent) -> void:
	# حركة الكاميرا بالماوس
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			var mouse_event = event as InputEventMouseMotion
			head.rotate_y(-mouse_event.relative.x * MOUSE_SENSITIVITY)
			camera.rotate_x(-mouse_event.relative.y * MOUSE_SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
	# إظهار/إخفاء الماوس
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# التفاعل مع الأبواب
	if event.is_action_pressed("interact"):
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider and collider.has_method("interact"):
				collider.interact()

func _physics_process(delta: float) -> void:
	# الجاذبية
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# القفز
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# الحركة
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * GROUND_DRAG)
		velocity.z = move_toward(velocity.z, 0, SPEED * GROUND_DRAG)
	
	move_and_slide()
