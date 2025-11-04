extends Object
class_name ConfigurationWarningHelper

static func collect_required_warnings(obj: Node, fields: Array[String]) -> Array[String]:
	var warnings = []
	for required in fields:
		var value = obj.get(required)
		var type = typeof(value)
		var requirement_met = true
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
	var warnings = []
	for animation in fields:
		var animation_name = obj.get(animation)
		if animation_name not in available_animations:
			warnings.append("Animation '" + animation_name + "' for export [" + animation + "] doesn't exist.")
	return warnings
