extends KinematicBody2D


#### PLAYER MOVEMENT & ANIMATION ####
export var player_movement_speed = 100
var velocity
var animation_player

var KEY_VALUES = {"W": 87, "A": 65, "S": 83, "D": 68, "SHIFT": 16777237}

func get_player_movement(key):
	velocity = Vector2()
	
	if Input.is_physical_key_pressed(key["W"]): velocity.y -= .5
	if Input.is_physical_key_pressed(key["A"]): velocity.x -= 1
	if Input.is_physical_key_pressed(key["S"]): velocity.y += .5
	if Input.is_physical_key_pressed(key["D"]): velocity.x += 1
		
	velocity = velocity.normalized() * player_movement_speed
	
	if velocity: animation_player.play("Run_Left")
	else: animation_player.play('Idle')


#### DASH LOGIC ####
var dash_timer
var dash_cooldown_timer
export var dash_duration = .25
export var dash_cooldown_duration = .1
var is_dashing = false
var is_cooling = false
export var dash_multiplier = 4

func define_dash_timer():
	dash_timer = Timer.new()
	dash_timer.set_one_shot(true)
	dash_timer.set_wait_time(dash_duration)
	dash_timer.connect("timeout", self, "end_dash")
	add_child(dash_timer)
	
func define_dash_cooldown_timer():
	dash_cooldown_timer = Timer.new()
	dash_cooldown_timer.set_one_shot(true)
	dash_cooldown_timer.set_wait_time(dash_cooldown_duration)
	dash_cooldown_timer.connect("timeout", self, "open_dash")
	add_child(dash_cooldown_timer)
	
func perform_dash():
	is_dashing = true
	print("DASH HAPPENING")
	dash_timer.start()
	
func end_dash():
	is_cooling = true
	is_dashing = false
	dash_cooldown_timer.start()
	
func open_dash(): is_cooling = false

func dash_if_so(event):
	if is_dashing || is_cooling || not event is InputEventKey || event.is_echo(): return
	if event.get_scancode() == KEY_VALUES["SHIFT"] && event.is_pressed():
		perform_dash()


#### ATTACK LOGIC ####
signal player_attack(attack)

export var player_damage = 5

func player_attack():
	var attack = Input.is_action_pressed("attack")
	if attack == true:
		$attack_box/damage_zone.disabled = false
		emit_signal('player_attack', player_damage)
	else:
		$attack_box/damage_zone.disabled = true
		print("im not attacking")


#### ENGINE ACTIONS ####
func _ready():
	animation_player = $AnimationPlayer
	define_dash_timer()
	define_dash_cooldown_timer()
	
func _physics_process(delta):
	if is_dashing: move_and_slide(velocity * dash_multiplier)
	else:
		get_player_movement(KEY_VALUES)
		move_and_slide(velocity)

func _input(event):
	dash_if_so(event)
	player_attack()




## for now this is jut some basic movment code for the pourpose of prototyping!
#
#export var speed = 200  

#
#var velocity = Vector2.ZERO
#var animation_player = null
#
#func _ready():
#	animation_player = $AnimationPlayer
#
## this is so the player moves isometricly in a grid some what.
#func cartision_to_isometric(cartision):
#	return Vector2(cartision.x - cartision.y, (cartision.x + cartision.y) / 2)
#
## getting input from the player
#func get_movement_input():
#	velocity = Vector2.ZERO
#
#	velocity.x = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#	velocity.y = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
#
#	velocity = velocity.normalized() * speed
#	print(velocity)
#	velocity = cartision_to_isometric(velocity)
#
#	if velocity != Vector2.ZERO:
#		animation_player.play("Run_Left")
#	else:
#		animation_player.play('Idle')
#
#

#
## all the players pysics
#func _physics_process(delta):
#	get_movement_input()
#	velocity = move_and_slide(velocity)
#
#func _input(event):
#	player_atack()

