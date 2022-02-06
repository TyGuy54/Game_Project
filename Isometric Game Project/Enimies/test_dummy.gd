extends KinematicBody2D


export var health = 15

func handle_hit():
	health -= 5
	print('Enemy health ', health)
	if health <= 0:
		queue_free()

