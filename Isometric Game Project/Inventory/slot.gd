extends Panel

var default_tex = preload("res://assests/inventory_assests/grey_box.png")
var empty_tex = preload("res://assests/inventory_assests/grey_box.png")

var default_style = null
var empty_style = null

var ItemClass = preload("res://item.tscn")
var item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex

	if randi() % 2 == 0:
		item = ItemClass.instance()
		add_child(item)
	refresh_style()

func refresh_style():
	if item == null:
		set('custom_styles/panel', default_style)
	else:
		set('custom_styles/panel', empty_style)
		

func pick_from_slot():
	remove_child(item)
	var inventory_node = find_parent("inventory")
	inventory_node.add_child(item)
	item = null
	refresh_style()
	
func put_into_slot(new_item):
	item = new_item
	item.position = Vector2.ZERO
	var inventory_node = find_parent("inventory")
	inventory_node.remove_child(item)
	add_child(item)
	refresh_style()
	
	




