extends RigidBody2D

@export var speed = 1.2
@export var maxSpeed = 2
@onready var player = $"../Player"

func _integrate_forces(state):
	var monsterPosition = position
	var playerPosition =  player.position
	var movementDirection = playerPosition - monsterPosition
	var movementVector = movementDirection.normalized()
	linear_velocity = Vector2(clamp(movementVector.x * speed, -maxSpeed, maxSpeed), linear_velocity.y)
