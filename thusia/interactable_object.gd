extends StaticBody3D

var is_open = false # متغير بيحفظ حالة الباب (مفتوح ولا مقفول)

func interact():
	# إنشاء Tween عشان يعمل حركة ناعمة ومريحة للعين
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	if not is_open:
		# لو الباب مقفول.. يلف حول محور Y بزاوية 90 درجة في خلال ثانية واحدة
		tween.tween_property(self, "rotation_degrees:y", 90.0, 1.0)
		is_open = true
		print("الباب اتفتح!")
	else:
		# لو الباب مفتوح.. يرجع للزاوية 0 ويقفل في خلال ثانية واحدة
		tween.tween_property(self, "rotation_degrees:y", 0.0, 1.0)
		is_open = false
		print("الباب اتقفل!")
