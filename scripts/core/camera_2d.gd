extends Camera2D

var _previousPosition: Vector2 = Vector2(0, 0)
var _drag: bool = false

var _target_zoom: float = 1.0
var _target_position: Vector2 = Vector2.ZERO

const MAX_ZOOM: float = 2.0 
const MIN_ZOOM: float = 0.1
const ZOOM_INCREMENT: float = 0.1
const ZOOM_RATE: float = 10.0 

func _ready() -> void:
	_target_zoom = zoom.x
	_target_position = global_position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed() and event.ctrl_pressed:
				_previousPosition = event.position
				_drag = true
			elif event.is_released():
				_drag = false
		
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_out()
			
	elif event is InputEventMouseMotion and _drag:
		var drag_offset = (_previousPosition - event.position) / zoom
		_target_position += drag_offset
		global_position = _target_position
		_previousPosition = event.position

func zoom_in():
	var new_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_zoom_target(new_zoom)

func zoom_out():
	var new_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_zoom_target(new_zoom)

func set_zoom_target(new_zoom_value: float):
	if is_equal_approx(new_zoom_value, _target_zoom):
		return
	
	var mouse_world_pos := get_global_mouse_position()
	_target_position = mouse_world_pos + (_target_position - mouse_world_pos) * (_target_zoom / new_zoom_value)
	_target_zoom = new_zoom_value
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	zoom = lerp(zoom, _target_zoom * Vector2.ONE, ZOOM_RATE * delta)
	global_position = lerp(global_position, _target_position, ZOOM_RATE * delta)
	
	set_physics_process(
		not is_equal_approx(zoom.x, _target_zoom) or 
		not global_position.is_equal_approx(_target_position)
	)
