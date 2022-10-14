extends Entity
class_name Player

@export var _friction : int

var _animationPlayer : AnimationPlayer
var _animationTree : AnimationTree
var _animationState
var _lastKeyPressed : String
var _isMoving : bool

func _ready():
	_animationPlayer = $PlayerAnimationPlayer
	_animationTree = $PlayerAnimationTree
	_animationState = _animationTree.get("parameters/playback")	
	
func _process(delta):
	
	calcVelocity(delta)
	


func calcVelocity(delta) :
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	direction = direction.normalized()
	
	if direction != Vector2.ZERO:
		_animationTree.set("parameters/Idle/blend_position", direction)
		_animationTree.set("parameters/Walk/blend_position", direction)
		_animationState.travel("Walk")
		moveTo(direction,delta)
		_velocity = _velocity.move_toward(direction * _max_speed, _acceleration * delta)
	else :
		_animationState.travel("Idle")
		stopMove(delta)


func get_class() :
	return "Player"





