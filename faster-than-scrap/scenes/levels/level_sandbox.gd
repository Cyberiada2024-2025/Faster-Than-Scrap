extends Node3D


func _ready() -> void:
	print("sand in the box")
	DebugMenu.disable_money_checks = true
	ShopContents.generate_all_modules()
