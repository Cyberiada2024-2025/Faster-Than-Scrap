class_name Mission

extends Node

## Base class for mission which will check its completion in game
## When created it will automaticaly set itself up by calling [setup()]

signal finished(mission: Mission)

enum MissionState { IN_PROGRESS, FINISHED, FAILED }

var state: MissionState = MissionState.IN_PROGRESS
var charged := false
var timeHolding: float = 0
@export var timeToHold: float = 2


func _ready() -> void:
	setup()


func setup() -> void:
	# add self to manager
	MissionManager.add_mission(self)


func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass
	# detect press
	# hold
	## animate
	#if Input.is_action_pressed("use_fuel") and charged == false:
	#if GameManager.player_ship.current_fuel > 0:
	#timeHolding += delta
	#if timeHolding >= timeToHold:
	#state = MissionState.FINISHED
	#finished.emit(self)
	#GameManager.player_ship.current_fuel -= 1
	#charged = true
	#else:
	#print("No hyperspace fuel!")
	#
	#if Input.is_action_just_pressed("use_fuel"):
	#if GameManager.player_ship.current_fuel > 0:
	## spawn tiemr
	#var timer := Timer.new()
	#add_child(timer)
	#timer.one_shot = true
	#timer.wait_time = 2
	#timer.timeout.connect(_use_fuel)
	#timer.start()
	#else:
	#print("No hyperspace fuel")
	##timeHolding += delta
	##if timeHolding >= timeToHold:
	##state = MissionState.FINISHED
	##finished.emit(self)
	##GameManager.player_ship.current_fuel -= 1
	##charged = true


#
#if Input.is_action_just_released("use_fuel"):
#get_child()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("use_fuel"):
		if GameManager.player_ship.current_fuel > 0:
			# spawn tiemr
			var timer := Timer.new()
			add_child(timer)
			timer.one_shot = true
			timer.wait_time = 2
			timer.timeout.connect(_use_fuel)
			timer.start()
		else:
			print("No hyperspace fuel")
			#timeHolding += delta
			#if timeHolding >= timeToHold:
			#state = MissionState.FINISHED
			#finished.emit(self)
			#GameManager.player_ship.current_fuel -= 1
			#charged = true

	if Input.is_action_just_released("use_fuel"):
		print("EEE")
		var timer: Timer
		for child in get_children():
			if child is Timer:
				timer = child
		timer.queue_free()
		#get_child()


func _use_fuel() -> void:
	state = MissionState.FINISHED
	finished.emit(self)
	GameManager.player_ship.current_fuel -= 1
	charged = true


## returns whether the missions ended.
## Either by success or failure
func _ended() -> bool:
	return state == MissionState.FINISHED or state == MissionState.FAILED


func create_label(text: String) -> Label3D:
	var label := Label3D.new()
	label.text = text
	label.font_size = 180
	label.position = Vector3(0, 0, 2)
	label.rotation_degrees = Vector3(270, 0, 0)
	return label
