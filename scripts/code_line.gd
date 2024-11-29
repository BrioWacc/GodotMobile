extends HBoxContainer

var type
var quantity

func set_type(t: String, q: int = 1):
	if (q <= 0):
		q = 1
		
	type = t
	
	if q == 1:
		$Label.text = t
		quantity = 1
	else:
		$Label.text = t + " " + str(q)
		quantity = q

