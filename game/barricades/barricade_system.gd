extends Node


const BLUEPRINT_DISTANCE := 64.0

@export var level: Level
@export var player: Player

var wood: int

var last_direction := Vector2.DOWN
@onready var current_blueprint: TileMapPattern = level.blueprint_h
@onready var current_barricade: TileMapPattern = level.barricade_h
var blueprint_position: Vector2


func _ready() -> void:
	Events.wood_collected.connect(on_wood_collected)
	Events.exit_reached.connect(on_exit_reached)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("build"):
		if wood <= 0:
			return
		
		if check_blueprint_collision():
			return
		
		wood -= 1
		Events.barricade_built.emit()
		var tile_position := level.local_to_map(blueprint_position)
		level.set_pattern(level.barricade_layer, tile_position, current_barricade)
		%snd_place.play()


func _physics_process(delta: float) -> void:
	level.clear_layer(level.blueprint_layer)
	
	if wood > 0:
		update_direction()
		
		blueprint_position = player.position + Vector2(0, -16) + last_direction * BLUEPRINT_DISTANCE
		
		# check for collision
		%RayCast.position = player.position + Vector2(0, -16)
		%RayCast.target_position = last_direction * BLUEPRINT_DISTANCE
		%RayCast.force_raycast_update()
		if %RayCast.is_colliding():
			blueprint_position = %RayCast.get_collision_point() - last_direction
		
		level.set_pattern(level.blueprint_layer, level.local_to_map(blueprint_position), current_blueprint)
		
		if check_blueprint_collision():
			level.set_layer_modulate(level.blueprint_layer, Color.RED)
		else:
			level.set_layer_modulate(level.blueprint_layer, Color.WHITE)


func check_blueprint_collision() -> bool:
	var grid_position := level.local_to_map(blueprint_position)
	
	if last_direction.x == 0:
		# blueprint goes right
		%RayCast.position = grid_position * Vector2i(32, 32) + Vector2i(1, 16)
		%RayCast.target_position = Vector2(62, 0)
		
	else:
		# blueprint goes down
		%RayCast.position = grid_position * Vector2i(32, 32) + Vector2i(16, 1)
		%RayCast.target_position = Vector2(0, 62)
	
	%RayCast.force_raycast_update()
	return %RayCast.is_colliding()


func on_wood_collected() -> void:
	wood += 1


func on_exit_reached() -> void:
	wood = 0


func update_direction() -> void:
	if Input.is_action_pressed("move_left"):
		last_direction = Vector2.LEFT
		current_blueprint = level.blueprint_v
		current_barricade = level.barricade_v
		
	elif Input.is_action_pressed("move_right"):
		last_direction = Vector2.RIGHT
		current_blueprint = level.blueprint_v
		current_barricade = level.barricade_v
		
	elif Input.is_action_pressed("move_up"):
		last_direction = Vector2.UP
		current_blueprint = level.blueprint_h
		current_barricade = level.barricade_h
		
	elif Input.is_action_pressed("move_down"):
		last_direction = Vector2.DOWN
		current_blueprint = level.blueprint_h
		current_barricade = level.barricade_h
