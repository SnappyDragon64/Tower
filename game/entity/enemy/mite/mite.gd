extends DirectionalCharacterBody2D


@export var speed := 100.0
@export var rotation_speed := 4.0

var first_frame_ignored = false
var hit_edge := false
var hit_wall := false
var is_rotating := false
var rotation_direction: Constants.Y_DIRECTION = Constants.Y_DIRECTION.UP
var rotation_progress: float


func _ready() -> void:
	super._ready()
	$Model.animation_player.play("crawl")


func set_direction(dir: Constants.X_DIRECTION) -> void:
	super.set_direction(dir)
	$Model.apply_direction(get_direction())
	$Raycasts.set_scale(Vector2(get_direction(), 1))


func _physics_process(delta: float) -> void:
	if is_rotating:
		rotation += delta * rotation_speed * get_direction() * rotation_direction
		rotation_progress += delta * rotation_speed

		if rotation_progress > Constants.HALF_PI:
			is_rotating = false
			rotation_progress = 0.0
			rotation = round(rotation / Constants.HALF_PI) * Constants.HALF_PI
			$Model.animation_player.play("crawl")
			
		set_up_direction(Vector2.UP.rotated(rotation))
	else:
		hit_edge = not $Raycasts/EdgeChecker.is_colliding()
		hit_wall = $Raycasts/WallChecker.is_colliding()
		
		if not first_frame_ignored: # Raycasts take 1 frame to report collision
			first_frame_ignored = true
			hit_edge = false

	if is_on_floor():
		if is_rotating and rotation_direction == Constants.Y_DIRECTION.DOWN:
			velocity = Vector2.ZERO
		else:
			velocity = -speed * get_up_direction().rotated(-90.0 * get_direction())
	
	velocity -= get_up_direction() * Constants.GRAVITY
	
	if is_on_floor() and hit_edge:
		is_rotating = true
		hit_edge = false
		rotation_direction = Constants.Y_DIRECTION.DOWN
		$Model.animation_player.play("crawl_down")
	elif hit_wall:
		is_rotating = true
		hit_wall = false
		rotation_direction = Constants.Y_DIRECTION.UP
		$Model.animation_player.play("crawl_up")
	
	move_and_slide()
