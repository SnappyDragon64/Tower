extends Node2D


@export var max_mana := 100.0
@export var pull := 400.0
@export var spark_value := 4.0
@export var max_spells := 4

@onready var spark_collector: Area2D = $SparkCollector

var active_spell := 0
var mana := 0.0
var player: Player
var spark_list: Array[Spark] = []
var dirty := false


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null)
	
	player.update_mana_bar(mana, max_mana, true)


func _physics_process(_delta) -> void:
	if Input.is_action_just_pressed("cycle_forward"):
		active_spell = (active_spell + 1) % max_spells
		UIManager.get_hud().set_active_spell(active_spell)
	elif Input.is_action_just_pressed("cycle_back"):
		active_spell = 3 if active_spell == 0 else active_spell - 1
		UIManager.get_hud().set_active_spell(active_spell)
	
	if mana < max_mana:
		for spark in spark_list:
			var distance = spark_collector.get_global_position() - spark.get_position()
			spark.velocity = distance.normalized() * pull
	elif dirty:
		dirty = false
		for spark in spark_list:
			spark.free = true


func _on_spark_attractor_body_entered(body):
	if body is Spark:
		body.free = false
		spark_list.append(body)
		dirty = true


func _on_spark_attractor_body_exited(body):
	if body is Spark:
		body.free = true
		spark_list.erase(body)


func _on_spark_collector_body_entered(body):
	if body is Spark and mana < max_mana:
		mana = min(mana + spark_value, max_mana)
		player.update_mana_bar(mana, max_mana)
		body.queue_free()
