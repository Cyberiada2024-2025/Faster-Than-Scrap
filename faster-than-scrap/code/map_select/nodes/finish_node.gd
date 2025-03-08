@tool

class_name FinishNode

extends MapNode

func _set_color() -> void:
	modulate = Color.BLACK
	super()

func get_description() -> String:
	return "Mission Type: \nTHE END"

func change_scene(scene_loader: SceneLoader) -> void:
	super(scene_loader)
	scene_loader.load_fly_ship_scene() # TODO change for credits scene
