class_name MissileTarget
extends Ship

## dummy ship instance for allowing missile to home target, which technically are not ships.
## For example vital points of a boss.


func _notification(notification: int) -> void:
	if notification == NOTIFICATION_PREDELETE:
		destroyed.emit(self)
