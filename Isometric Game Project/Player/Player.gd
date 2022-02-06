extends KinematicBody2D

signal player_attack(attack)

# for now this is jut some basic movment code for the pourpose of prototyping!

export var speed = 200  
export var player_damage = 5

var velocity = Vector2.ZERO
var animation_player = null

func _ready():
	animation_player = $AnimationPlayer

# this is so the player moves isometricly in a grid some what.
func cartision_to_isometric(cartision):
	return Vector2(cartision.x - cartision.y, (cartision.x + cartision.y) / 2)

# getting input from the player
func get_movement_input():
	velocity = Vector2.ZERO
	
	velocity.x = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity.y = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	
	velocity = velocity.normalized() * speed
	print(velocity)
	velocity = cartision_to_isometric(velocity)
	
	if velocity != Vector2.ZERO:
		animation_player.play("Run_Left")
	else:
		animation_player.play('Idle')
	
	
func player_atack():
	var attack = Input.is_action_pressed("attack")
	if attack == true:
		$attack_box/damage_zone.disabled = false
		emit_signal('player_attack', player_damage)
	else:
		$attack_box/damage_zone.disabled = true
		print("im not attacking")
		
# all the players pysics
func _physics_process(delta):
	get_movement_input()
	velocity = move_and_slide(velocity)
	
func _input(event):
	player_atack()

