extends RigidBody2D

@export var speed = 1.2
@export var maxSpeed = 2
@onready var player = $"../Player"


var states = ['Bushcamp', 'Follow', 'Search']
var currentState = 1

func _process(delta):
	if (currentState == 0):
		Bushcamp(delta)
	if (currentState == 1):
		Follow(delta)
	if (currentState == 2):
		Search(delta)

func Bushcamp(delta: float):
	pass
	
func Follow(delta: float):
	var monsterPosition = position
	var playerPosition =  player.position
	var movementDirection = playerPosition - monsterPosition
	var movementVector = movementDirection.normalized()
	linear_velocity = Vector2(clamp(movementVector.x * speed, -maxSpeed, maxSpeed), linear_velocity.y)

func Search(delta: float):
	pass



func setState(state : int):
	currentState = clamp(state, 0, states.count - 1)

func getState(intState = currentState):
	return states[intState]
