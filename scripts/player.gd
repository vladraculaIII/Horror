extends CharacterBody2D

@onready var StaminaRegainTimer = $NoStaminaTimer
@onready var PlayerSprite = $Sprite2D
@onready var PlayerCrouch = "res://textures/player_crouch_test.png"
@onready var PlayerIdle = "res://textures/player_test.png"
var cameraRef

const SPEED = 150.0
const SPRINT_SPEED = 1.5
const JUMP_VELOCITY = -300.0
const MAX_STAMINA = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_hide = false
var is_hiding = false

var jumpable = false
var staminaRegen = false
var sprinting = false
var stamina = 100.0


func _ready():
	cameraRef = get_node("CameraPivot")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle running.
	if Input.is_action_pressed("sprint") and is_on_floor() and !staminaRegen:
		if is_hiding:
			hide_interact()
		sprinting = true
		stamina -= 1.5
	else:
		sprinting = false
	
	#Handle hiding.
	if can_hide and Input.is_action_just_pressed("interact"):
		hide_interact()

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and jumpable and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if is_hiding:
			velocity.x /= SPRINT_SPEED
		elif sprinting:
			cameraRef.change_zoom(1)
			velocity.x *= SPRINT_SPEED
		else:
			cameraRef.change_zoom(0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _process(delta):
	#Handle stamina.
	if stamina < MAX_STAMINA and !sprinting:
		stamina += 0.15
	if stamina <= 0:
		staminaRegen = true
		StaminaRegainTimer.start()
	print(stamina)

	#Handle turning around.
	if get_global_mouse_position().x > global_position.x:
		PlayerSprite.scale.x = 0.178
	elif get_global_mouse_position().x < global_position.x:
		PlayerSprite.scale.x = -0.178


func _on_no_stamina_timer_timeout():
	staminaRegen = false


func hide_interact():
	if is_hiding:
		PlayerSprite.texture = load(PlayerIdle)
		cameraRef.change_zoom(0)
	else:
		PlayerSprite.texture = load(PlayerCrouch)
		cameraRef.change_zoom(2)
	is_hiding = !is_hiding
