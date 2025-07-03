class_name ShipController

extends RigidBody3D

## class used mostly for enemy to allow compatibility
## with player implementation and to allow control of the enemy.

@export var ship: Ship

## If set to true, ship_controller's linear and angular velocities will be set
## to Vector3.ZERO in every subsequent call of state machine's state_physics_update method.
## In most cases this should be set to true, as the velocities are set by the specific states.
var should_reset_velocities = true
