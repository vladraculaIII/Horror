extends Node2D

var is_taken_by_monster = false
var monster_reference

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_reach_area_body_entered(body):
	if body.is_in_group("player"):
		body.can_hide = true
		if is_taken_by_monster:
			is_taken_by_monster = false
			monster_reference.setState(1)
		
	elif body.is_in_group("monster"):
		monster_reference = body
		if body.currentState == 0:
			is_taken_by_monster = true
			body.Hide()


func _on_reach_area_body_exited(body):
	if body.is_in_group("player"):
		body.can_hide = false
		if body.is_hiding:
			body.hide_interact()
