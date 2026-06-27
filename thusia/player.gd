extends CharacterBody3D

# إعدادات الحركة الأساسية
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003

# جلب الجاذبية من إعدادات المشروع
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# ربط العقد
@onready var head = $head
@onready var camera = $head/Camera3D
@onready var raycast = $head/Camera3D/RayCast3D

func _ready():
	# إخفاء الماوس وحبسه في المركز
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	# حركة الكاميرا بالماوس
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		# تحديد زاوية النظر
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
	# إظهار/إخفاء الماوس بزر Esc
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# التفاعل مع الأبواب بزر E
	if event.is_action_pressed("interact"):
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider.has_method("interact"):
				collider.interact()

func _physics_process(delta):
	# إضافة الجاذبية
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# القفز
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# الحركة بـ WASD
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# تطبيق الحركة
	move_and_slide()
