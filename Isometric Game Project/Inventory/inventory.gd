extends Node2D

const SLOT_CLASS = preload("res://Inventory/slot.gd")
onready var inventory_slots = $GridContainer
var holding_item = null

# ========================================================================================================
# Called when the node is "ready", i.e. when both the node and its children have entered the scene tree. 
# If the node has children, their _ready() callbacks get triggered first, 
# and the parent node will receive the ready notification afterwards.
# ========================================================================================================
func _ready():
	for inv_slots in inventory_slots.get_children():
		# ========================================================================================================
		# self - Refers to current class instance
		# It serves essentially the same purpose as self or this in other object-oriented languages
		#
		# Specifically in GDScript, when used in a script, 
		# it's a reference to the object the script is attached to.
		#
		# It's used whenever you need a reference to the current node, for 
		# example when connecting a signal to a local function.
		# ========================================================================================================
		inv_slots.connect("gui_input", self, "slot_gui_input", [inv_slots])
		
		
func slot_gui_input(event: InputEvent, slot: SLOT_CLASS):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if holding_item != null:
				if !slot.item: # place item into slot
					slot.put_into_slot(holding_item)
					holding_item = null
				else: # swaping holding item with item in slot
					var tmp_item = slot.item
					slot.pick_from_slot()
					tmp_item.global_position = event.global_position
					slot.put_into_slot(holding_item)
					holding_item = tmp_item
			elif slot.item:
				holding_item = slot.item
				slot.pick_from_slot()
				holding_item.global_position = get_global_mouse_position()
				
func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
