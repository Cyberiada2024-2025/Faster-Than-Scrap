@tool

class_name BossNode

extends MapNode

func _set_color() -> void:
	modulate = Color.RED
	super()


func get_description() -> String:
	return "Mission Type: \nBoss"


func change_scene(scene_loader: SceneLoader) -> void:
	super(scene_loader)
	scene_loader.load_fly_ship_scene() # TODO change to boss scene?
