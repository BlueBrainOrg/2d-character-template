extends Object
class_name ConfigurationWarningHelper

static func collect_required_warnings(obj: Node, fields: Array[String]) -> Array[String]:
	var warnings: Array[String] = []
	for required in fields:
		var value: Variant = obj.get(required)
		var type := typeof(value) as Variant.Type
		var requirement_met := true
		match type:
			TYPE_NIL:
				requirement_met = false
			TYPE_STRING:
				requirement_met = value != ""
			TYPE_STRING_NAME:
				requirement_met = str(value) != ""
		
		if not requirement_met:
			warnings.append("required export variable [" + required + "] missing")
	return warnings


static func collect_animation_warnings(obj: Node, fields: Array[String], available_animations: Array[String]) -> Array[String]:
	var warnings: Array[String] = []
	for animation_field in fields:
		var animation_name: Variant = obj.get(animation_field)
		assert(animation_name is String, "Field [" + animation_field + "] is not a string type but was registered as an animation")
		if animation_name not in available_animations:
			warnings.append("Animation '" + animation_name + "' for export [" + animation_field + "] doesn't exist.")
	return warnings


static func collect_input_warnings(actions: Array[String]) -> Array[String]:
	InputMap.load_from_project_settings()
	var warnings: Array[String] = []
	for action in actions:
		if not InputMap.has_action(action):
			warnings.append("Specified input action [" + action + "] does not exist")
	return warnings
