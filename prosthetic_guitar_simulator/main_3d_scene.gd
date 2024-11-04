extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_cams()
	pass

func handle_cams():
	var cameras = [
		get_node("MainCamera"),
		get_node("GuitarNeckCamera"),
		get_node("GuitarNeckCamera2"),
		get_node("GuitarNeckCamera3"),
		get_node("GuitarNeckCamera4")
	]
	
	if Input.is_action_just_pressed("cycleCam"):
		for i in range(cameras.size()):
			if cameras[i].is_current():
				cameras[i].clear_current(true)
				# Set the next camera in the array as the current one, looping back to the first camera
				var next_index = (i + 1) % cameras.size()
				cameras[next_index].make_current()
				break
