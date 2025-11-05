@icon("res://addons/plenticons/icons/16x/custom/jump-to-yellow.png")
@tool
extends Node
class_name StateTransition

@export var to_state: CharacterControllerState:
	set(val):
		to_state = val
		update_configuration_warnings()

## Priority used when requesting a state change, higher values take priority over lower values.
@export var priority : int = 0

## Override used when requesting a state change, if true this request will override previous
## requests if both have the same priority.
@export var override_same_priority := false

## data sent to the state change request, only useful if the to_state enter method implements
## data handling.
@export var data: Dictionary = {}

@export var dynamic_data: Dictionary[String, DynamicDataRow] = {}

var parent : CharacterControllerState
var state_machine: CharacterControllerStateMachine

func _should_run():
	if Engine.is_editor_hint():
		return false
	if not parent.is_active:
		return false
	return true

func _ready():
	if Engine.is_editor_hint():
		return

	var _parent = get_parent()
	assert(_parent is CharacterControllerState, "DynamicStateTransition parent must be CharacterControllerState")
	parent = _parent
	var _state_machine: CharacterControllerStateMachine
	
	await get_tree().physics_frame
	if parent is CharacterControllerStateMachine:
		state_machine = parent
	else:
		state_machine = parent.state_machine

func get_all_data():
	var result = {}
	result.merge(data)
	for key in dynamic_data:
		var row = dynamic_data[key]
		var row_object = get_node(row.object)
		var value = row_object.get(row.property)
		if value is Callable:
			value = value.call()
		result[key] = value
	return result
