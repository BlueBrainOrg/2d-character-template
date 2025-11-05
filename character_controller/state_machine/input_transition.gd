@tool
extends StateTransition
class_name InputStateTransition

## InputMap action name to listen to
@export var input: String:
	set(val):
		input = val
		update_configuration_warnings()

@export_multiline var condition: String = ""

func _physics_process(_delta: float) -> void:
	if not _should_run():
		return
	
	var condition_result = true
	if condition != "":
		var expression = Expression.new()
		expression.parse(condition)
		condition_result = expression.execute([], state_machine.actor)

	if Input.is_action_just_pressed(input) and condition_result:
		state_machine.request_state_change(to_state.name, get_all_data(), priority)


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
