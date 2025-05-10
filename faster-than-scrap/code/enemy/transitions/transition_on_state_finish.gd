class_name TransitionOnStateFinish
extends baseTransition

## This class should not be overused! It is supposed to be used in states, which
## are hard to determine how long should the last. For example the state
## (move to position) should change when it reach the destination. It can take
## different each time, or the destination will be different each time.
## Thus, for this instances this transition could be used.


func relay() -> void:
	finished.emit(new_state.name)
