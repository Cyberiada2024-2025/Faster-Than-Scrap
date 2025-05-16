extends PlayerDetector

signal on_pick


func _ready() -> void:
	super()

	player_entered.connect(
		func():
			on_pick.emit()
			queue_free()
	)
