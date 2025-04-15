class_name TimedTransition

extends baseTransition

@export var duration: float = 0

var counter : float = 0;
var timer_finished: bool = false
var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_finished)

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_previous_state_path: String, _data := {}) -> void:
	timer_finished = false
	timer.start(duration)


func condition() -> void:
	if timer_finished:
		finished.emit(new_state.name)

func _on_timer_finished() -> void:
	timer_finished = true
