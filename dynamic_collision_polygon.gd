extends CollisionPolygon2D

func _ready():
	var child = get_children()[0]
	if not child is Polygon2D:
		queue_free()
	polygon = child.polygon
