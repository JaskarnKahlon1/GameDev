extends Node2D

@export var brick_scene: PackedScene  # The brick scene to instantiate
@export var bricks_per_level: int = 25  # Number of bricks for Level 1
@export var min_brick_distance: float = 100.0  # Minimum distance between bricks
var rng = RandomNumberGenerator.new()  #random positions
var placed_bricks_positions: Array = []  #store the positions of already placed bricks, goal is to make sure they dont overlap

func _ready() -> void:
	start_level_1()  # Start Level 1 with random bricks

func start_level_1() -> void:
	print("Starting Level 1")
	
	# Get the screen dimensions
	var width = get_viewport_rect().size.x
	var height = get_viewport_rect().size.y / 2  # makes sure bricks are only on upper half of the screen
	
	# Place bricks randomly on the screen,making sure they dont overlap
	for i in range(bricks_per_level):
		var new_brick = brick_scene.instantiate()
		var valid_position = false
		var random_position: Vector2
		
		# Try finding a position that doesn't overlap with existing bricks
		while not valid_position:
			random_position = Vector2(rng.randf_range(0, width), rng.randf_range(0, height))
			valid_position = check_position(random_position)
		
		# Set brick position and add to the scene
		new_brick.position = random_position
		add_child(new_brick)
		new_brick.add_to_group("Bricks")  # Add the brick to the "Bricks" group
		
		# Store position of the brick
		placed_bricks_positions.append(random_position)

	# check when all bricks are destroyed
	set_process(true)

# Function to check if the new position overlaps with existing bricks
func check_position(new_position: Vector2) -> bool:
	for placed_position in placed_bricks_positions:
		if placed_position.distance_to(new_position) < min_brick_distance:
			return false  # Position is too close to an existing brick
	return true  # No overlap, position is valid

# Check if all bricks are destroyed
func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("Bricks").size() == 0:
		print("All bricks destroyed!")
		set_process(false)  # Stop checking once all bricks are gone
