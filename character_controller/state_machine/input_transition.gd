@tool
extends StateTransition
class_name InputStateTransition

var _input_exports: Array[String] = ["input"]

## InputMap action name to listen to
@export var input: String:
	set(val):
		input = val
		update_configuration_warnings()

@export_multiline var condition: String = ""

func _ready() -> void:
	super()
	_required_exports.append("input")

func _physics_process(_delta: float) -> void:
	if not _should_run():
		return


	if Input.is_action_just_pressed(input):
		var condition_result := true
		if condition != "":
			var expression := Expression.new()
			expression.parse(condition)
			condition_result = expression.execute([], state_machine.actor)
		if condition_result:
			change_state()


func _get_configuration_warnings() -> PackedStringArray:
	var packed_warnings: PackedStringArray = super()
	var warnings: Array[String] = []
	warnings += ConfigurationWarningHelper.collect_input_warnings(self, _input_exports)
	packed_warnings += PackedStringArray(warnings)
	
	return packed_warnings
