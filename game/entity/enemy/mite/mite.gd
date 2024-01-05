extends DirectionalCharacterBody2D


@export var speed := 100.0

var rotate_flag := false
var rotate_direction: Constants.Y_DIRECTION = Constants.Y_DIRECTION.UP
var hit_edge := false
var hit_wall := false
var flag = false
var acc: float


func _ready() -> void:
	super._ready()
	$Model.animation_player.play("crawl")


func set_direction(dir: Constants.X_DIRECTION) -> void:
	super.set_direction(dir)
	$Model.apply_direction(get_direction())
	$Raycasts.set_scale(Vector2(get_direction(), 1))


func _physics_process(delta: float) -> void:
	if rotate_flag:
		hit_edge = false
		hit_wall = false
		
		rotation += delta * 4 * get_direction() * rotate_direction
		acc += delta * 4

		if acc > Constants.HALF_PI:
			rotate_flag = false
			rotation = round(rotation / Constants.HALF_PI) * Constants.HALF_PI
			$Model.animation_player.play("crawl")
			
		set_up_direction(Vector2.UP.rotated(rotation))
	else:
		hit_edge = not $Raycasts/EdgeChecker.is_colliding()
		hit_wall = $Raycasts/WallChecker.is_colliding()
		
		if not flag:
			flag = true
			hit_edge = false

	if is_on_floor():
		velocity = -speed * get_up_direction().rotated(-90.0 * get_direction()) * (0 if rotate_flag and rotate_direction == Constants.Y_DIRECTION.DOWN else 1)
	velocity -= get_up_direction() * Constants.GRAVITY
	
	if is_on_floor() and hit_edge:
		rotate_flag = true
		rotate_direction = Constants.Y_DIRECTION.DOWN
		acc = 0.0
		$Model.animation_player.play("crawl_down")
	elif hit_wall:
		rotate_flag = true
		rotate_direction = Constants.Y_DIRECTION.UP
		acc = 0.0
		$Model.animation_player.play("crawl_up")
	
	move_and_slide()
