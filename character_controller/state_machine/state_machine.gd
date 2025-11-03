extends CharacterControllerState
class_name CharacterControllerStateMachine

@export var default_state: CharacterControllerState
@export var always_active := true  ## set to false if used as a nested state_machine
@export var is_root := false

var states: Dictionary[StringName, CharacterControllerState] = {}
var current_state: StringName = ""

var state_change_request_to : StringName = ""
var state_change_request_data : Dictionary = {}
var state_change_request_is_pending := false


func enter(_from, _data):
	pass


func exit(_to, _data):
	pass


func physics_tick(delta):
	if current_state:
		states[current_state].physics_tick(delta)


func render_tick(delta):
	if current_state:
		states[current_state].render_tick(delta)


func _handle_state_change_request():
	force_change_state(state_change_request_to, state_change_request_data)
	state_change_request_is_pending = false


func request_state_change(to: StringName, data: Dictionary = {}, override := false):
	if state_change_request_is_pending and not override:
		push_warning("State change request rejected: another request is pending")
		return
	state_change_request_to = to
	state_change_request_data = data
	if not state_change_request_is_pending:
		state_change_request_is_pending = true
		_handle_state_change_request.call_deferred()


func force_change_state(to: StringName, data: Dictionary):
	var from = current_state
	current_state = to
	print("changing state: " + from + "->" + to)
	if data:
		print("data sent:")
		print(data)
	states[from].exit(to, data)
	states[to].enter(from, data)


func add_state(state_node: CharacterControllerState):
	var state_name = state_node.name
	if state_name in states:
		push_error("Duplicate state " + state_name)
		return
	states[state_name] = state_node
	state_node.state_machine = self
	state_node.actor = actor
	if state_node == default_state:
		current_state = state_name 


func _ready() -> void:
	if is_root:
		actor = get_parent()
	for child in get_children():
		if child is CharacterControllerState:
			add_state(child)


func _physics_process(delta: float) -> void:
	if always_active:
		physics_tick(delta)


func _process(delta: float) -> void:
	if always_active:
		render_tick(delta)
