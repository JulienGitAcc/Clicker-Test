extends Node2D

@export var block_scene: PackedScene
@export var block_size: Vector2 = Vector2(33, 33)



func _ready():
	generate_blocks()
	
	
func generate_blocks():
	var start_x = -6 * block_size.x
	var start_y = -5 * block_size.y
	var rows = 10
	var cols = 5
	
	for row in range(rows):
		for col in range (cols):
			spawn_block(Vector2(start_x + col * block_size.x, start_y + row * block_size.y))
			spawn_block(Vector2((block_size.x * (col + 2)), start_y + row * block_size.y))
			

func spawn_block(pos:Vector2):
	var block = block_scene.instantiate()
	block.position = pos
	if randf() < 0.05:
		block.type = "gold"
	else:
		block.type = "empty"
	$Blocks.add_child(block)
