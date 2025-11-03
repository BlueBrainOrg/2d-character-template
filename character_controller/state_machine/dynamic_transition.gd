extends Node
class_name DynamicStateTransition

@export var to_state: CharacterControllerState
@export var input: String
@export var priority := false
@export var data: Dictionary = {}
@onready var parent = get_parent()

func _physics_process(_delta: float) -> void:
	if not parent.state_machine.current_state == parent.name:
		return
	if not input:
		return
	if Input.is_action_just_pressed(input):
		parent.state_machine.request_state_change(to_state.name, data, priority)
