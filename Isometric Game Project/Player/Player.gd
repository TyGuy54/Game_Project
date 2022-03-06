extends player_stats # inhereits from player_class.gd


#### PLAYER MOVEMENT & ANIMATION ####
export var player_movement_speed = 100
var velocity
var animation_player
onready var sword = get_node("sword")
onready var sword_animation = sword.get_node("Sword_animatoin_player")

# a constant for player input for WSAD and SHIFT
var KEY_VALUES = {"W": 87, "A": 65, "S": 83, "D": 68, "SHIFT": 16777237}

# player movemnt function that takes in a key as the parameter
# The function handles player movment physics
func get_player_movement(key):
	velocity = Vector2()
	
	if Input.is_physical_key_pressed(key["W"]): velocity.y -= .5
	if Input.is_physical_key_pressed(key["A"]): velocity.x -= 1
	if Input.is_physical_key_pressed(key["S"]): velocity.y += .5
	if Input.is_physical_key_pressed(key["D"]): velocity.x += 1
		

	velocity = velocity.normalized() * player_movement_speed
	
	if velocity: 
		animation_player.play("Run_Left")
	else: 
		animation_player.play('Idle')


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
	
func open_dash(): 
	is_cooling = false

func dash_if_so(event):
	if is_dashing or is_cooling or not event is InputEventKey or event.is_echo(): 
		return
	if event.get_scancode() == KEY_VALUES["SHIFT"] && event.is_pressed():
		perform_dash()

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
	if Input.is_action_pressed("attack") and not sword_animation.is_playing():
		sword_animation.play("player_attack")
