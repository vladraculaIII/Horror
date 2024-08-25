extends RigidBody2D

@export var speed = 200
@export var maxSpeed = 500
@onready var player = $"../Player"
@onready var hidingTimer = $Timer


var states = ['Bushcamp', 'Follow', 'Search']
var currentState = 0
var looksForSpot = true

func _process(delta):
	if (currentState == 0):
		Bushcamp(delta)
	if (currentState == 1):
		Follow(delta)
	if (currentState == 2):
		Search(delta)

func Bushcamp(delta: float):

	#This complicated mess finds the closest hideable object on the X axis
	if looksForSpot:
		var targetsToCamp = get_tree().get_nodes_in_group("hideable_object")
		var distanceArray = []
		var targetPosition
		var targetToHideIn
		
		for obj in targetsToCamp:
			if distanceArray.size() > 0:
				var previousTargetPos = targetPosition
				targetPosition = obj.position - position
				if abs(targetPosition.x) < abs(previousTargetPos.x):
					targetToHideIn = targetPosition
				else:
					targetToHideIn = previousTargetPos
			else:
				targetPosition = obj.position - position
			distanceArray.insert(distanceArray.size(), targetPosition)
	
		#And this copy of Oskar's code moves the monster towards it
		#However, if the target has a different Y, it moves slower (depending on how big Y difference is)
		#Because I blatanty stole it, his code has the same issue (or a feature)
		var movementVector = targetToHideIn.normalized()
		linear_velocity = Vector2(clamp(movementVector.x * speed, -maxSpeed, maxSpeed), linear_velocity.y)
	else:
		#Something was moving the monster while nothing was impacting its position
		#So I set the x Force in the Constant Forces field from 3 to 0
		#It fixed it but idk what I did
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
	currentState = clamp(state, 0, states.size())
	if state == 1: looksForSpot = true

func getState(intState = currentState):
	return states[intState]

func Hide():
	hidingTimer.start()

func _on_timer_timeout():
	looksForSpot = false
	print("ready")
