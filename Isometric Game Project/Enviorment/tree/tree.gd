extends StaticBody2D

export var tree_health = 25
export var item_log = preload("res://Enviorment/tree/log.tscn")

func handle_hit():
	tree_health -= 5
	print('Tree Health ', tree_health)
	if tree_health <= 0:
		dropped_item()
		print("droped item: log")
		queue_free()

func dropped_item():
	var item = item_log.instance()
	item.position = position
	get_parent().add_child(item)
