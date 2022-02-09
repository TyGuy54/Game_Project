extends KinematicBody2D

func _ready():
	get_node("CollisionShape2D").set_deferred("disabled", true)
