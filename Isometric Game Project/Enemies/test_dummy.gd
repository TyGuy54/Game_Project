extends KinematicBody2D


var velocity = Vector2.ZERO
var player = null

export var run_speed = 30
export var health = 15

# enemy health 
func handle_hit():
	health -= 5
	print('Enemy health ', health)
	if health <= 0:
		queue_free()

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * run_speed
	velocity = move_and_slide(velocity)

func _on_alert_zone_body_entered(body):
	 player = body

func _on_alert_zone_body_exited(body):
	player = null
