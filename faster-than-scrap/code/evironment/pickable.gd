extends PlayerDetector


func _ready() -> void:
	super()
	player_entered.connect(func(): queue_free())
