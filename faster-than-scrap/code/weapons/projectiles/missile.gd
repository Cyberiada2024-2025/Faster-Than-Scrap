class_name Missile

extends Projectile

## Curve representing the missile's turn rate in time. (degrees per second)
## [code]X = 1[/code] on the curve represents the end of the projectile's lifetime.
## Useful for example to make the missile not turn immediately after spawning.
@export var turn_rate: Curve

## Turn rate from the [param turn_rate] curve will be multiplied by this number.
## This makes it easier to quickly adjust the missile's turn rate.
@export var turn_rate_multiplier: float = 1

## The team this missile belongs to. It will only consider ships from enemy teams as valid targets.
@export var team: TeamManager.Team

## Weight of the enemy distance in target choosing calculations.
## The total weight is calculated like so: [br]
## [code]distance_to_enemy * distance_weight + angle_to_enemy * angle_weight[/code] [br]
## If the missile has no target (when the missile is just instantiated,
## or when the previous target died), enemy with the lowest weight is chosen.
@export var distance_weight: float = 5

## Weight of the angle to enemy in target choosing calculations. The angle is specified in degrees.
## For more details, see: [member distance_weight]
@export var angle_weight: float = 1

## The object this missile follows
var target: Node3D


func _process(delta: float) -> void:
	super(delta)
	_process_rotation(delta)
	if target == null or not target.is_inside_tree():
		target = _find_target()


func _find_target() -> Node3D:
	var enemies = GameManager.find_all_enemies(team)
	if enemies.size() == 0:
		return null

	var original_quaternion: Quaternion = quaternion

	var chosen_enemy: Ship
	var lowest_weight: float = INF
	for ship in enemies:
		look_at(ship.global_position)
		var target_quaternion: Quaternion = quaternion
		var angle = rad_to_deg(original_quaternion.angle_to(target_quaternion))
		var distance = ship.global_position.distance_to(global_position)

		var weight = distance * distance_weight + angle * angle_weight
		print(ship, " angle=", angle, " distance=", distance, " weight=", weight)
		if weight < lowest_weight:
			chosen_enemy = ship
			lowest_weight = weight

	quaternion = original_quaternion

	return chosen_enemy


func _process_rotation(delta: float) -> void:
	if not target:
		return

	var turn_speed = turn_rate.sample_baked(_current_lifetime / lifetime)
	turn_speed *= turn_rate_multiplier

	var original_quaternion: Quaternion = quaternion
	look_at(target.global_position)
	var target_quaternion: Quaternion = quaternion

	quaternion = QuaternionUtilities.rotate_towards(
		original_quaternion, target_quaternion, turn_speed * delta
	)
