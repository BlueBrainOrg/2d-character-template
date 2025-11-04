@icon("res://addons/plenticons/icons/16x/custom/jump-to-yellow.png")
@tool
extends Node
class_name DynamicStateTransition

@export var to_state: CharacterControllerState:
	set(val):
		to_state = val
		update_configuration_warnings()

## InputMap action name to listen to
@export var input: String:
	set(val):
		input = val
		update_configuration_warnings()

## Priority used when requesting a state change, higher values take priority over lower values.
@export var priority : int = 0

## Override used when requesting a state change, if true this request will override previous
## requests if both have the same priority.
@export var override_same_priority := false

## data sent to the state change request, only useful if the to_state enter method implements
## data handling.
@export var data: Dictionary = {}

var parent : CharacterControllerState

var state_machine: CharacterControllerStateMachine


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


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if not parent.is_active:
		return

	if Input.is_action_just_pressed(input):
		state_machine.request_state_change(to_state.name, data, priority)


func _get_configuration_warnings():
	InputMap.load_from_project_settings()
	var warnings = []
	
	if input == null or input == "":
		warnings.append("No input specified for transition")
	elif not InputMap.has_action(input):
		warnings.append("Specified input action does not exist")
	
	if to_state == null:
		warnings.append("No to_state defined")
	
	if not get_parent() is CharacterControllerState:
		warnings.append("Transitions need to be nested below state or state machine")
	
	return warnings
