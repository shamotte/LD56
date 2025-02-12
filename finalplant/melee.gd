extends Node

@export var parent : Node
@export var anim : AnimationPlayer	 
@export var anim_name : String
var target : BeeControler
var attack_counter : int = 0

var is_active : bool

func enter() -> void:
	parent.set_attacking(true)
	$Timer.start()
	is_active = true
	anim.play(anim_name)
	target = parent.get_new_target()
	if attack_counter == 0:
		attack_counter = randi_range(2,4)
	
	#anim.animation_finished.connect(next_state,ConnectFlags.CONNECT_ONE_SHOT)

func next_state():
	attack_counter -= 1
	if attack_counter == 0:
		get_parent().change_state("HideTeeth")
		return
	get_parent().change_state("MeleeCharge")
	

func update(delta: float) -> void:
	if target == null:
		parent.get_new_target()
		return
	#print("(Final",target.global_position)
	parent.look_at(target.global_position)
	$"../../Node2D/Sprite2D".rotation = deg_to_rad(90)
	#$"../../Sprite2D".rotation = 90
func exit() -> void:
	is_active = false
	$Timer.stop()

func _on_timer_timeout() -> void:
	next_state()
