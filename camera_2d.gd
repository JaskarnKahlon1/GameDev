extends Camera2D

@export var randomStrength: float = 30.0 #this is the max strength
@export var shakeFade: float = 1.0

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

var defaultOffX: float = 575.0
var defaultOffY: float = 330.0
var default_offset: Vector2  # Store the default offset as a Vector2

func _ready() -> void:
	# Set the default offset on ready
	default_offset = Vector2(defaultOffX, defaultOffY)
	offset = default_offset

func apply_shake():
	shake_strength = randomStrength

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shake"):
		apply_shake()
	
	if shake_strength > 0:
		# Gradually reduce the shake strength
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		
		# Set the offset to default plus the shake offset
		offset = default_offset + randomOffset()
	else:
		# Reset to the default offset when shake is done
		offset = default_offset

func randomOffset() -> Vector2:
	# Generate a random offset based on the shake strength
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
