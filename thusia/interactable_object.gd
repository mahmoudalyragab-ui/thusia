extends StaticBody3D

# حالة الباب
var is_open = false

func interact():
	# إنشاء تحريك ناعم
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	if not is_open:
		# فتح الباب
		tween.tween_property(self, "rotation_degrees:y", 90.0, 1.0)
		is_open = true
		print("تم فتح الباب!")
	else:
		# إغلاق الباب
		tween.tween_property(self, "rotation_degrees:y", 0.0, 1.0)
		is_open = false
		print("تم إغلاق الباب!")
