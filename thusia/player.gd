extends CharacterBody3D

# إعدادات الحركة الأساسية
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003 # حساسية حركة الماوس لف الشاشة

# جلب الجاذبية من إعدادات المشروع أوتوماتيكياً
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# ربط العقد (Nodes) بالـ Script
@onready var head = $head
@onready var camera = $head/Camera3D
@onready var raycast = $head/Camera3D/RayCast3D

func _ready():
	# أول ما اللعبة تفتح، اخفي الماوس واحسبه في نص الشاشة
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	# 1. حركة الكاميرا بالماوس (تشتغل بس لما يكون الماوس مخفي ومحبوس)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		# تحديد زاوية النظر لفوق وتحت عشان الكاميرا متقلبش ورا ضهر اللاعب
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	# 2. زرار الـ Esc لإظهار وإخفاء الماوس أثناء التجربة
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# 3. نظام التفاعل عند الضغط على حرف E
	if event.is_action_pressed("interact"):
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider.has_method("interact"):
				collider.interact()

func _physics_process(delta):
	# إضافة الجاذبية لو اللاعب مش لامس الأرض
	if not is_on_floor():
		velocity.y -= gravity * delta

	# القفز عند الضغط على زر القفز (المسطرة Space)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# جلب اتجاه الحركة من أزرار الـ WASD أو الأسهم
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# تطبيق الحركة والاصطدام
	move_and_slide()
