class_name RandomTransition extends StateNPC

## Class which is state and transition at the same time.
## It's supposed to be used a relay for default transition to allow
## branching transition with weighted propabilities.
## In the tree it's supposed to be next to the states, and it has children
## of type WeighedProbability.


class StateProbability:
	extends Resource
	var state: State
	var probability: float

	func _init(new_state: State, state_probability: float) -> void:
		self.state = new_state
		self.probability = state_probability


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
	var states_prob: Array[StateProbability] = []
	for state in new_states:
		var prob = float(state.weight) / sum
		states_prob.append(StateProbability.new(state.state, prob))

	var t = randf()
	for state in states_prob:
		if t < state.probability:
			# change to that state
			finished.emit(state.state.name)
			return
		t -= state.probability

	# in case it didn't find any (float precision error?)
	# emit last
	finished.emit(states_prob[states_prob.size() - 1].state.name)
