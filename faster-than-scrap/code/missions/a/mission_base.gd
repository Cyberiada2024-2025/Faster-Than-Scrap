class_name Mission

extends Node

## Base class for mission which will check its completion in game
## When created it will automaticaly set itself up by calling [setup()]

signal finished(mission: Mission)

enum MissionState { IN_PROGRESS, FINISHED, FAILED }
enum Priority { MAIN_QUEST, SIDE_QUEST }

@export var priority: Priority = Priority.MAIN_QUEST
@export var time_to_hold: float = 2

@export_category("Vortex paramaters")
@export var _use_custom_vortex_size: bool = false
@export var _custom_vortex_size: float = 400
@export var jump_circle: CircleProgressBar

var state: MissionState = MissionState.IN_PROGRESS
var timer: Timer


func _ready() -> void:
	setup()


func setup() -> void:
	# add self to manager
	MissionManager.add_mission(self)


func _process(_delta: float) -> void:
	if jump_circle != null:
		jump_circle.set_percentage(1.0 - timer.time_left / timer.wait_time)


func _create_circle():
	# I tried to use VBox and do it in HUD scene but spaghetti got too real
	var circle_center: Vector2 = get_window().size - Vector2i.ONE * 50
	circle_center.y -= get_window().size.y / 1.26
	circle_center.x += get_window().size.y / 120

	jump_circle = CircleProgressBar.new()
	add_child(jump_circle)
	jump_circle.position = circle_center


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("use_fuel"):
		if GameManager.player_ship.current_fuel > 0:
			timer = Timer.new()
			add_child(timer)
			timer.one_shot = true
			timer.wait_time = time_to_hold
			timer.timeout.connect(_use_fuel)
			timer.name = "hyperdrive"
			timer.start()
			_create_circle()
		else:
			print("No hyperspace fuel")

	if Input.is_action_just_released("use_fuel"):
		if jump_circle != null:
			jump_circle.queue_free()
			for child in get_children():
				if child.name == "hyperdrive":
					child.queue_free()


func _use_fuel() -> void:
	state = MissionState.FINISHED
	finished.emit(self)
	GameManager.player_ship.current_fuel -= 1


## returns whether the missions ended.
## Either by success or failure
func _ended() -> bool:
	return state == MissionState.FINISHED or state == MissionState.FAILED


func _spawn_vortex(target_position: Vector3) -> void:
	if _use_custom_vortex_size:
		SpaceVortex.spawn_vortex(target_position, _custom_vortex_size)
	else:
		SpaceVortex.spawn_vortex(target_position)
