@icon("res://addons/bluebrains_character_controller/icons/jump-to-yellow.png")
@tool
extends Node
class_name StateTransition

var _required_exports: Array[String] = ["to_state"]

@export var to_state: CharacterControllerState:
	set(val):
		to_state = val
		update_configuration_warnings()

## Priority used when requesting a state change, higher values take priority over lower values.
@export var priority : int = 0

## Override used when requesting a state change, if true this request will override previous
## requests if both have the same priority.
@export var override_same_priority := false

@export var force_change_on_not_allowed := false

## data sent to the state change request, only useful if the to_state enter method implements
## data handling.
@export var data: Dictionary[String, Variant] = {}

@export var dynamic_data: Dictionary[String, DynamicDataRow] = {}

var parent : CharacterControllerState
var state_machine: CharacterControllerStateMachine

func _should_run() -> bool:
	if Engine.is_editor_hint():
		return false
	if not parent.is_active:
		return false
	var allow_change: bool = parent.allow_state_change or force_change_on_not_allowed
	if not allow_change:
		return false
	
	return true

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	var _parent : Node = get_parent()
	assert(_parent is CharacterControllerState, "DynamicStateTransition parent must be CharacterControllerState")
	parent = _parent
	var _state_machine: CharacterControllerStateMachine
	
	await get_tree().physics_frame
	if parent is CharacterControllerStateMachine:
		state_machine = parent
	else:
		state_machine = parent.state_machine

func get_all_data() -> Dictionary[String, Variant]:
	var result: Dictionary[String, Variant] = {}
	result.merge(data)
	for key in dynamic_data:
		var row: DynamicDataRow = dynamic_data[key]
		var row_object : Node = get_node(row.object)
		var value: Variant = row_object.get(row.property)
		if value is Callable:
			value = value.call()
		result[key] = value
	return result


func change_state() -> void:
	if OS.is_debug_build():
		print()
	state_machine.request_state_change(to_state.name, get_all_data(), priority, override_same_priority)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	warnings += ConfigurationWarningHelper.collect_required_warnings(self, _required_exports)
	
	if not get_parent() is CharacterControllerState:
		warnings.append("Transitions need to be nested below state or state machine")
	
	return warnings
