@tool

class_name FinishNode

extends MapNode

func _set_color() -> void:
	super()
	modulate = Color.BLACK

func get_description() -> String:
	return "Mission Type: \nTHE END"

func change_scene(sceneLoader: SceneLoader) -> void:
	super(sceneLoader)
	sceneLoader.load_fly_ship_scene() # TODO change for credits scene
