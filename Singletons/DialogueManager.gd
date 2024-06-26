extends Node

@onready var chat_box_scene = preload("res://Scenes/chat_box.tscn")

var chat_lines: Array[String] = []
var current_line_index = 0
var chat_box
var chat_box_pos: Vector2
var is_chat_active = false
var can_advance_line = false

# starts a new active chat
func start_chat(position: Vector2, lines: Array[String]):
	if is_chat_active:
		return # don't start chat if chat is already active
		
	chat_lines = lines
	chat_box_pos = position
	_show_chat_box()
	
	is_chat_active = true

# set up new chat box scene
func _show_chat_box():
	chat_box = chat_box_scene.instantiate()
	
	# get signal from chat box when ready for new line
	chat_box.finished.connect(_on_chat_box_finished)
	get_tree().root.add_child(chat_box)
	
	# set chat box text and position
	chat_box.global_position = chat_box_pos
	chat_box.display_text(chat_lines[current_line_index])
	can_advance_line = false

func _on_chat_box_finished():
	can_advance_line = true

# handle input
func _unhandled_input(event):
	if (
		event.is_action_pressed("advance_text") &&
		is_chat_active &&
		can_advance_line
	):
		chat_box.queue_free()
		current_line_index += 1
		
		# chat finished
		if current_line_index >= chat_lines.size():
			is_chat_active = false 
			current_line_index = 0 # reset line index
			return
			
		_show_chat_box()
