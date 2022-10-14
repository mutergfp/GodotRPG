extends CharacterBody2D
class_name Entity

@export var _max_health: int
@export var _armor: int
@export var _strenght: int
@export var _max_speed: int
@export var _acceleration: int

signal hit(damages)

var _health : int
var _velocity : Vector2
var _target_instance : Entity :
	get:
		return _target_instance # TODOConverter40 Copy here content of get_target_instance
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_target_instance
var _hit_box : CollisionObject2D
var _attack_box : CollisionObject2D


#func _init(hit_box,attack_box):
func _init():
	_health = _max_health
	_velocity = Vector2.ZERO
	_target_instance = null
	#_hit_box = hit_box
	#_attack_box = attack_box


func attack():
	emit_signal("hit")
	
func sub_health(amount_health):
	if (amount_health > _health):
		_health -= amount_health 
	else:
		_health -= _health
	return _health
	

func trigger_hit_target(damages):
	sub_health(_strenght - _armor)

##GETTER SETTER##
func set_target_instance(target_instance):
	if(_target_instance):
		disconnect("hit",Callable(_target_instance,"trigger_hit"))
	_target_instance = target_instance
	connect("hit",Callable(_target_instance,"trigger_hit"))
	
func get_target_instance():
	return _target_instance
	
func moveTo(direction, delta):
	_velocity = _velocity.move_toward(direction * _max_speed, _acceleration * delta)
	set_velocity(_velocity)
	move_and_slide()
	
func stopMove(delta, friction = 500):
	_velocity = _velocity.move_toward(Vector2.ZERO, friction * delta)
	set_velocity(_velocity)
	move_and_slide()
		
