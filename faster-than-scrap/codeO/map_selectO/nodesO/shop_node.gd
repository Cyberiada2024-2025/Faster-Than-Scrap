@tool
class_name ShopNode

extends MapNode

func _set_color() -> void:
	modulate = Color.YELLOW
	super()

func get_description() -> String:
	return "Shop node!"

func change_scene(scene_loader: SceneLoader) -> void:
	super(scene_loader)
	scene_loader.load_build_ship_scene()
