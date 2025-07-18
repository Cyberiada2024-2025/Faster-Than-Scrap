class_name StateMachineNPC extends Node

## The initial state of the state machine. If not set, the first child node is used.
@export var initial_state: State = null

@export var can_be_knocked_out: bool = false

@export var knocked_out_state: State = null

#onready - children (states) are available
#anonymous function to make sure starting state is set (with fallback)
#call - invoke anonymous function
## The current state of the state machine.
@onready var state: StateNPC = (
	(func get_initial_state() -> State:
		return initial_state if initial_state != null else get_child(0))
	. call()
)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Give every state a reference to the state machine.
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)

	if can_be_knocked_out:
		owner.contact_monitor = true
		if owner.max_contacts_reported <= 0:
			owner.max_contacts_reported = 10
		owner.body_entered.connect(_on_owner_body_entered)

	# State machines usually access data from the root node of the scene they're part of: the owner.
	# We wait for the owner to be ready to guarantee all the data and nodes the states may need
	# are available.
	await owner.ready
	state.enter("")


func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr(
			(
				owner.name
				+ ": Trying to transition to state "
				+ target_state_path
				+ " but it does not exist."
			)
		)
		return
	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)
	# start each transition
	for t in state.transitions:
		t.enter(previous_state_path, data)


func _process(delta: float) -> void:
	state.state_update(delta)


func _physics_process(delta: float) -> void:
	state.state_physics_update(delta)
	for t in state.transitions:
		t.state_physics_update(delta)
		t.condition()


func _on_owner_body_entered(_body: Node) -> void:
	_transition_to_next_state(knocked_out_state.name)
