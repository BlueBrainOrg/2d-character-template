@tool
extends AnimatedSprite2D
@export var fps := 5.0
@export_tool_button("Update FPS") var update_fps_tool_button : Callable = update_fps

var parent: Node

func _ready() -> void:
	parent = get_parent()

func update_fps() -> void:
	for animation_name in sprite_frames.get_animation_names():
		sprite_frames.set_animation_speed(animation_name, fps)

func _process(_delta: float) -> void:
	if "looking_left" in parent:
		flip_h = parent.looking_left
