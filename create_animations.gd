@tool
extends EditorScript

var loop_names: Array[String] = ["idle", "walk", "run", "climb", "spin", ]

func add_animation(sheet_path: String, dirty_anim_name: String) -> void:
	var sprite_frames: SpriteFrames = load("res://character_controller/sprite_frames.tres")
	var existing_animations := sprite_frames.get_animation_names()
	var clean_anim_name := dirty_anim_name.to_snake_case().replace("(", "").replace(")", "")
	if clean_anim_name in existing_animations:
		sprite_frames.remove_animation(clean_anim_name)
	
	var sprite_sheet := load(sheet_path) as Texture2D
	
	var sheet_width := sprite_sheet.get_width()
	var sheet_height := sprite_sheet.get_height()
	
	var file_name := sheet_path.rsplit("/", true, 1)[1]
	var regex := RegEx.new()
	regex.compile(".+?([0-9]+)x([0-9]+).png")
	var result := regex.search(file_name)
	if not result:
		print("Sprite name did not match pattern")
		return
	
	var cell_width := int(result.get_string(1))
	var cell_height := int(result.get_string(2))
	
	var x_cells: int = sheet_width / cell_width
	var y_cells: int = sheet_height / cell_height
	
	sprite_frames.add_animation(clean_anim_name)
	for xi in range(x_cells):
		for yi in range(y_cells):
			var sprite_atlas := AtlasTexture.new()
			sprite_atlas.atlas = sprite_sheet
			sprite_atlas.region = Rect2(xi*cell_width, yi*cell_height, cell_width, cell_height)
			sprite_frames.add_frame(clean_anim_name, sprite_atlas)

func _run() -> void:
	print("running")
	var sprite_frames: SpriteFrames = load("res://character_controller/sprite_frames.tres")
	for animation in sprite_frames.get_animation_names():
		sprite_frames.remove_animation(animation)
	
	var animation_folder := "res://character_controller/sprites/"
	var dir := DirAccess.open(animation_folder)
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
				var bla := animation_folder + file_name
				print(bla)
				var anim_dir := DirAccess.open(animation_folder + file_name)
				if anim_dir:
					var files := anim_dir.get_files()
					print(files)
					var candidates : Array[String] = []
					for file in files:
						if file.ends_with(".png"):
							candidates.append(file)
					print(candidates.size())
					if candidates.size() > 1:
						print("Found more than one file in folder, skipping")
						file_name = dir.get_next()
						continue
					if candidates.size() == 0:
						print("No sprites file found in folder")
						file_name = dir.get_next()
						continue
					add_animation(animation_folder + file_name + "/" + candidates[0], file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	
	print("================================")
	for animation_name in sprite_frames.get_animation_names():
		var frames := sprite_frames.get_frame_count(animation_name)
		if frames == 0:
			print("Found empty animation: " + animation_name)
