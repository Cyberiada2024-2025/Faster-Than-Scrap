class_name RandomTransition extends StateNPC

## Class which is state and transition at the same time.
## It's supposed to be used a relay for default transition to allow
## branching transition with weighted propabilities.
## In the tree it's supposed to be next to the states, and it has children
## of type WeighedPropability.


class StatePropability:
	extends Resource
	var state: State
	var propability: float

	func _init(state: State, propability: float) -> void:
		self.state = state
		self.propability = propability


var new_states: Array[WeighedState]


func _ready() -> void:
	new_states.assign(find_children("*", "WeighedState"))


## Called by the state machine on the engine's main loop tick.
func state_update(_delta: float) -> void:
	# find total sum of weight
	var sum: int = 0
	for state in new_states:
		sum += state.weight

	# create new array with propabilities
	var states_prob: Array[StatePropability] = []
	for state in new_states:
		var prob = float(state.weight) / sum
		states_prob.append(StatePropability.new(state.state, prob))

	var t = randf()
	for state in states_prob:
		if t < state.propability:
			# change to that state
			finished.emit(state.state.name)
			return
		t -= state.propability

	# in case it didn't find any (float precision error?)
	# emit last
	finished.emit(states_prob[states_prob.size() - 1].state.name)
