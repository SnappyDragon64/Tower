extends CharacterBody2D


@export var speed := 100.0

var rotate_down = false
var rotate_up = false
var hit_edge = false
var hit_wall = false
var flag = false
var acc: float


func _ready():
	$Model.animation_player.play("crawl")


func _physics_process(delta):
	if rotate_down:
		hit_edge = false
		rotation -= delta * 4
		acc += delta * 4

		if acc > Constants.HALF_PI:
			rotate_down = false
			rotation = round(rotation / Constants.HALF_PI) * Constants.HALF_PI
			$Model.animation_player.play("crawl")
			
		set_up_direction(Vector2.UP.rotated(rotation))
	elif rotate_up:
		hit_wall = false
		rotation += delta * 4
		acc += delta * 4
		
		if acc > Constants.HALF_PI:
			rotate_up = false
			rotation = round(rotation / Constants.HALF_PI) * Constants.HALF_PI
			$Model.animation_player.play("crawl")
		
		set_up_direction(Vector2.UP.rotated(rotation))
	else:
		hit_edge = not $Raycasts/EdgeChecker.is_colliding()
		hit_wall = $Raycasts/WallChecker.is_colliding()
		
		if not flag:
			flag = true
			hit_edge = false

	velocity = speed * get_up_direction().rotated(-90.0) * (0 if rotate_down else 1)
	velocity += get_up_direction() * -1 * 100
	
	if is_on_floor() and hit_edge:
		rotate_down = true
		acc = 0.0
		$Model.animation_player.play("crawl_down")
	elif hit_wall:
		rotate_up = true
		acc = 0.0
		$Model.animation_player.play("crawl_up")
	
	move_and_slide()
