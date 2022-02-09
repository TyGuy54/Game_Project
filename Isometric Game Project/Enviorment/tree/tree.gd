extends StaticBody2D

export var tree_health = 25


func handle_hit():
	tree_health -= 5
	print('Tree Health ', tree_health)
	if tree_health <= 0:
		dropped_item()
		print("droped item: log")
		queue_free()

func dropped_item():
	var item_log = preload("res://Enviorment/tree/log.tscn")
	var item = item_log.instance()
	item.position = $Position2D.global_position
	get_parent().call_deferred("add_child", item)

	
