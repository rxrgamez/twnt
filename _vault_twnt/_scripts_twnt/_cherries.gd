extends Area2D

#@onready var _game_manager_twnt = true
#func _ready():
	#update_environment() 

# Cherry collectible script
func _on_body_entered(body):
	if (body.name == "_ninja_toad"):
		body._process_collectible()  # Call the method directly on the ninja toad
		queue_free()
	



