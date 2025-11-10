extends CollisionPolygon2D

func _ready() -> void:
	var child: Node = get_children()[0]
	if not child is Polygon2D:
		queue_free()
	polygon = child.polygon
