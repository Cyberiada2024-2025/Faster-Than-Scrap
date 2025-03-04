@tool
class_name ShopNode

extends MapNode

func _set_color() -> void:
	modulate = Color.YELLOW
	super()

func get_description() -> String:
	return "Shop node!"

func change_scene(sceneLoader: SceneLoader) -> void:
	super(sceneLoader)
	sceneLoader.load_build_ship_scene()
