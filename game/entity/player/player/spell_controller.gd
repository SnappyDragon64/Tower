extends Node2D


@export var max_mana := 100.0
@export var mana_regen := 0.4
@export var max_spells := 4
@export var spell_cost := 24.0

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var heal_effect_preload: PackedScene = preload("res://game/entity/effect/heal.tscn")

var active_spell := 0
var mana := 0.0
var player: Player
var cooldown := false
var charging := false


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null)
	
	player.update_mana_bar(mana, max_mana, true)
	UIManager.get_hud().set_active_spell(active_spell)


func _physics_process(_delta) -> void:
	if not player.attacking:
		if Input.is_action_just_pressed("charge"):
			player.charging = true
			charging = true
			$Charge.start()
		
		if Input.is_action_just_released("charge"):
			player.charging = false
			charging = false
			$Charge.stop()
		
		if charging:
			mana = min(mana + mana_regen, max_mana)
			player.update_mana_bar(mana, max_mana, true)
		
		if can_cast() and Input.is_action_just_pressed("spell"):
			UIManager.get_hud().start_cooldown()
			mana -= spell_cost
			player.update_mana_bar(mana, max_mana)
			start_cooldown()
			cast_spell()
	
	if Input.is_action_just_pressed("cycle_forward"):
		active_spell = (active_spell + 1) % max_spells
		UIManager.get_hud().set_active_spell(active_spell)
	elif Input.is_action_just_pressed("cycle_back"):
		active_spell = 3 if active_spell == 0 else active_spell - 1
		UIManager.get_hud().set_active_spell(active_spell)


func can_cast() -> bool:
	return not charging and not cooldown and mana >= spell_cost


func start_cooldown() -> void:
	cooldown = true
	cooldown_timer.start()


func cast_spell() -> void:
	if active_spell == 0:
		pass


func _on_cooldown_timeout():
	cooldown = false
