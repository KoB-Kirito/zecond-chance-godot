class_name DialogBubble
extends Node2D

const MAX_WIDTH = 120


func _ready() -> void:
	%Bubble.hide()


func show_text(text: String) -> void:
	%TextLabel.text = text
	%Bubble.show()


func hide_text() -> void:
	%Bubble.hide()


func _on_text_label_minimum_size_changed() -> void:
	# godot UI nodes have no maximum size yet, so some shenanigans are needed
	if %TextLabel.get_minimum_size().x > MAX_WIDTH:
		%TextLabel.custom_minimum_size = Vector2(MAX_WIDTH, 0)
		%TextLabel.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
