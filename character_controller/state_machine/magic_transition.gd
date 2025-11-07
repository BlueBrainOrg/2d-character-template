@tool
extends StateTransition
class_name MagicStateTransition

## if true, will check condition every frame if parent state is active, set to false if using signals
@export var auto_check := false

## This expression will be executed as if by the actor
@export_multiline var condition := ""


func _physics_process(_delta: float) -> void:
	if auto_check:
		check_state_change()

func check_state_change() -> void:
	if not _should_run():
		return
	var expression := Expression.new()
	expression.parse(condition)
	if expression.execute([], state_machine.actor):
		change_state()
