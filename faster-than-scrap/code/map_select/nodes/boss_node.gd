@tool

class_name BossNode

extends MapNode

func _set_color() -> void:
	super()
	modulate = Color.RED


func get_description() -> String:
	return "Mission Type: \nBoss"


func change_scene(sceneLoader: SceneLoader) -> void:
	super(sceneLoader)
	sceneLoader.load_fly_ship_scene() # TODO change to boss scene?
