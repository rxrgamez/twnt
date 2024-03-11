extends CharacterBody2D

# Node references.
@onready var _sprite_ninja_toad = $_sprite_ninja_toad

# Speed and jump constants.
var SPEED = 320.0
var JUMP_VELOCITY = -300.0

# Physics settings.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Collectable handling.
var collectible_count = 0
var scale_level = 0

# Signals.
signal collectible_taken

# All Functions
func _process_collectible():
	emit_signal("collectible_taken")
	# _process_collectible()
	collectible_count += 1
	if collectible_count >= 5 and scale_level < 4:
		_sprite_ninja_toad.scale *= 1.15
		scale_level += 1
		collectible_count = 0 # reset for next growth cycle
	 # Adjust speed based on scale_level
		adjust_speed_based_on_scale()

func adjust_speed_based_on_scale():
	# Example: Reduce speed when small, increase when larger
	match scale_level:
		0:
			SPEED = 320  # Smaller size, faster speed
			JUMP_VELOCITY = -150.0
		1:
			SPEED = 300  # Normal size, normal speed
			JUMP_VELOCITY = -400.0
		2, 3:
			SPEED = 275  # Larger size, slower speed // more dense
			JUMP_VELOCITY = -500.0

func _physics_process(delta):
		
	# Animations
	# Animations
	if velocity.x > 1 or velocity.x < -1:
		_sprite_ninja_toad.animation = "_nt1_1_run"
	else:
		_sprite_ninja_toad.animation = "_nt1_0_idle"

	# Handle jump
	# Handle jump
	if not is_on_floor():
		velocity.y += gravity * delta
		_sprite_ninja_toad.animation = "_nt1_2_jump"
	# Handle jump Input
	# Handle jump Input
	if Input.is_action_just_pressed("_jump_basic") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("_move_left", "_move_right")
	if direction != 0:
		velocity.x = direction * SPEED
		_sprite_ninja_toad.flip_h = direction < 0  # Correctly set flip based on direction
	else:
		velocity.x = move_toward(velocity.x, 0, 40)

	move_and_slide()

