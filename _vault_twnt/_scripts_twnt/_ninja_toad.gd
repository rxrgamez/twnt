extends CharacterBody2D

# Node references.
@onready var _sprite = $_sprite_ninja_toad

# Physics settings.
var SPEED = 320.0
var JUMP_VELOCITY = -500.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Jump control.
var just_landed = false # Variable to detect if the player just landed
var can_double_jump = false
@onready var _jump_timer: Timer = $_jump_timer


# Collectable and scaling.
var collectible_count = 0
var scale_level = 0


# Signals.
signal collectible_taken

# Functions

#func _ready():
	#_jump_timer.wait_time = 0.3 # Timer for the double jump window
	#_jump_timer.one_shot = true # Timer will not repeat itself
	#_jump_timer.connect("timeout", self, "_on_jump_timer_timeout")
	
#func _on_jump_timer_timeout():
	#can_double_jump = true  # Disable double jumping when the timer runs out





func _process_collectible():
	emit_signal("collectible_taken")
	collectible_count += 1
	if collectible_count >= 8 and scale_level < 4:
		_sprite.scale *= 1.25
		scale_level += 1
		collectible_count = 0
	adjust_speed_based_on_scale()


func adjust_speed_based_on_scale():
	match scale_level:
		0: SPEED = 310; JUMP_VELOCITY = -250.0
		1: SPEED = 270; JUMP_VELOCITY = -400.0
		2, 3: SPEED = 325; JUMP_VELOCITY = -500.0





func _physics_process(delta):
	var direction = Input.get_axis("_move_left", "_move_right")
	if direction != 0:
		velocity.x = direction * SPEED
		_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, 40)
	
	velocity.y += gravity * delta

	if is_on_floor():
		just_landed = false
		can_double_jump = true # Allow for double jump after landing
		_sprite.animation = "_nt1_1_run" if direction != 0 else "_nt1_0_idle"
		can_double_jump = true  # Reset double jump when on floor
		if Input.is_action_just_pressed("_jump_basic"):
			velocity.y = JUMP_VELOCITY
		if just_landed:
			# Player just landed, start the double jump window timer
			_jump_timer.start()
			just_landed = false
	else:
		if just_landed == false:
			just_landed = true # Player is in the air
			if can_double_jump and Input.is_action_just_pressed("_jump_basic"):
				velocity.y = JUMP_VELOCITY * 1.5 # Higher jump for double jump
				can_double_jump = false # No more jumps available

	move_and_slide()

	
	
	


