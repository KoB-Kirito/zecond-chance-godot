extends CanvasLayer

var wood: int:
	set(value):
		wood = value
		if wood <= 0:
			%Wood.hide()
		else:
			%Wood.show()
			%WoodLabel.text = str(wood)


func _ready() -> void:
	show()
	
	Events.wood_collected.connect(on_wood_collected)
	Events.barricade_built.connect(on_barricade_built)
	Events.exit_reached.connect(on_exit_reached)
	
	%Wood.hide()


func on_wood_collected() -> void:
	wood += 1


func on_barricade_built() -> void:
	wood -= 1


func on_exit_reached() -> void:
	wood = 0
