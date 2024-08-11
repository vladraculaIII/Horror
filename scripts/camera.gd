extends Node2D

@onready var camera = $Camera2D

const ZOOM_NORM = 1.7
const ZOOM_RUN = 2.0
const ZOOM_HIDE = 2.5

var cam_zoom = [ZOOM_NORM, ZOOM_RUN, ZOOM_HIDE]
var cam_zoom_target = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera.zoom.x != cam_zoom[cam_zoom_target]:
		camera.zoom.x = lerp(camera.zoom.x, cam_zoom[cam_zoom_target], 0.1)
		camera.zoom.y = camera.zoom.x

func change_zoom(cam_id):
	cam_zoom_target = cam_id
