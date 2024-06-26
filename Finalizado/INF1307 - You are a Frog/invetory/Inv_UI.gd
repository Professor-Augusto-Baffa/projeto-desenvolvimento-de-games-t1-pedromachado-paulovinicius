extends Control

@onready var inv: Inv = preload("res://invetory/playerinv.tres")
@onready var slots:Array = $NinePatchRect/GridContainer.get_children()

var is_open = false
signal slot_clicked(Array)


func _ready():
	connectSlots()
	update_slots()
	close()

func connectSlots():
	for slot in slots:
		var callabe = Callable(onSlotClicked)
		callabe = callabe.bind(slot)
		slot.pressed.connect(callabe)


func update_slots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func _process(delta):
	if Input.is_action_just_pressed("i"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
	
func onSlotClicked(slot):
	slot_clicked.emit(slot)
	pass
