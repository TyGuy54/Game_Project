extends KinematicBody2D
class_name character

##CHARACTER MOVEMENT PHYSICS##
const FRICTION = 0.15

export var acceleration = 40
export var max_speed = 100

var move_direction = Vector2.ZERO
var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	
func move():
	move_direction = move_direction.normalized()
	velocity += move_direction * acceleration
