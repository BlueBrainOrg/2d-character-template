@tool
extends AnimatedSprite2D
@export var fps := 5.0
@export_tool_button("Update FPS") var _update_fps = update_fps

var parent

func _ready():
	parent = get_parent()

func update_fps():
	for animation_name in sprite_frames.get_animation_names():
		sprite_frames.set_animation_speed(animation_name, fps)

func _process(_delta: float) -> void:
	if "looking_left" in parent:
		flip_h = parent.looking_left
