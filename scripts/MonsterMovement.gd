extends RigidBody2D

@export var speed = 200
@onready var player = $"../Player"
@onready var hidingTimer = $Timer
@onready var targetsToCamp = get_tree().get_nodes_in_group("hideable_object")


var states = ['Bushcamp', 'Follow', 'Search']
var currentState = 2

var looksForSpot = true
var searchSpotArrayIndex = 0

func _process(delta):
	if (currentState == 0):
		Bushcamp(delta)
	elif (currentState == 1):
		Follow(delta)
	elif (currentState == 2):
		Search(delta)

func Bushcamp(delta: float):
	if looksForSpot:
		var distanceArray = []
		var targetPosition
		var targetToHideIn
		
		#finds the closest object on x-axis
		for obj in targetsToCamp:
			distanceArray.append(abs(obj.position.x - position.x))
			targetToHideIn = targetsToCamp[distanceArray.find(distanceArray.min())].position
		moveTowardsPoint(targetToHideIn, 5) #I set the precision to 5 as it made the monster stop reliably in a hiding spot.
	
func Follow(delta: float):
	moveTowardsPoint(player.position, 0)

func Search(delta: float):
	var searchSpots = targetsToCamp #hopefully this is a hard copy
	
	#reshuffles the search array if no valid entries are left
	if searchSpots.size() <= searchSpotArrayIndex:
		searchSpotArrayIndex = 0
		searchSpots.shuffle()
	var searchspot = searchSpots[searchSpotArrayIndex].position
	moveTowardsPoint(searchspot, 5)

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

func moveTowardsPoint(point : Vector2, precision : float):
	#This only works because the movement is supposed to be one dimensional.
	var movementDistance = point - position
	
	if movementDistance.x > abs(precision):
		linear_velocity = Vector2(speed, linear_velocity.y)
	
	elif movementDistance.x < -abs(precision):
		linear_velocity = Vector2(-speed, linear_velocity.y)
		
	else:
		linear_velocity = Vector2.ZERO
