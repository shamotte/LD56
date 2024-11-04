extends CharacterBody2D
class_name BeeControler


signal dash_finished(BeeControler)
signal bee_dies(BeeControler)

var direction : Vector2
@export_group("Movement")
@export var acceleration : float = 40

@export var max_speed : float = 500

@export var random_shpere_radius : float = 50

@export var tween_duration: float = 0.2
var direction_tween: Tween

var side_acceleration : float
#Components
@export_group("Components")
@export var backpack : Node		##Component of backpack

@export var manager: Node2D

var dashing : bool
var dash_started: bool
	

func _physics_process(delta):
	velocity = lerp(velocity,direction * max_speed ,0.5)
	
	$Sprites.look_at(velocity.rotated(PI/2))
	if $StateMachine.state.name == "Dash":
		$Sprites.modulate = Color(100.0, 100.0, 100.0)
	elif $CompBackpack.is_full():
		$Sprites.modulate = Color.YELLOW
	else:
		$Sprites.modulate = Color.WHITE
	move_and_slide()	
	
func provide_new_target_location(target: Vector2):
	$StateMachine/FlyTowards.set_new_target_location(target)

func new_target(target_position : Vector2):
	if direction_tween:
		direction_tween.kill()
		
	var new_direction = (target_position - position).normalized()

	direction_tween = create_tween()
	direction_tween.tween_property(self,"direction",new_direction,tween_duration)
	direction_tween.set_trans(Tween.TRANS_SPRING)	
	
func get_backpack():
	return backpack
	
	
func dash():
	if direction_tween:
		direction_tween.kill()
	$StateMachine.do_dash()
	
func end_dash():
	$StateMachine/Dash.end_dash_prematurely()
	
func bee_died():
	bee_dies.emit(self)
	
func can_deal_damage() -> bool:
	return $StateMachine.state.name == "Dash"
	


func _on_tree_exiting() -> void:
	manager.bees.erase(self)
	manager.UI.set_bees_amount(manager.get_amount_of_bees())
	manager.cursour_folowing.erase(self)
	manager.dashing_bees.erase(self)
	
