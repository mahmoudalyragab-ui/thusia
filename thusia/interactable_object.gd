extends StaticBody3D

var is_open = false

func interact():
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	if not is_open:
		tween.tween_property(self, "rotation_degrees:y", 90.0, 0.5)
		is_open = true
		print("✓ تم فتح الباب")
	else:
		tween.tween_property(self, "rotation_degrees:y", 0.0, 0.5)
		is_open = false
		print("✗ تم إغلاق الباب")
