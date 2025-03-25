class_name EnterShop

extends PlayerDetector

var scene_loader: SceneLoader


func _ready() -> void:
	super()
	player_entered.connect(_show_ui)
	scene_loader = SceneLoader.new()
	add_child(scene_loader)


func _show_ui() -> void:
	_enter_shop()


func _enter_shop() -> void:
	scene_loader.load_build_ship_scene()
