extends character # inhereits from character.tscn


# player movemnt function that takes in a key as the parameter
# The function handles player movment physics
func get_player_movement():
	move_direction = Vector2()
	
	if Input.is_action_pressed("ui_up"): 
		move_direction += Vector2.UP
	if Input.is_action_pressed("ui_down"): 
		move_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"): 
		move_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"): 
		move_direction += Vector2.RIGHT
