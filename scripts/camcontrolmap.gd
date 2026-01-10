extends TextureRect

var current_camera : String = "CAM1A"

@onready var bonnie = $"../../BonnieAI"

func update_camera_view(cam_name: String) -> void:
	print("Checking camera: ", cam_name)
	
	if has_node("../../ShowStage"): $"../../ShowStage".visible = false
	
	match cam_name:
		"CAM1A": # Show Stage
			$"../../ShowStage".visible = true
			
			var b_here = (bonnie.current_state == bonnie.State.SHOW_STAGE)
			
			if b_here:
				$"../../ShowStage".frame = 1
			else:
				print("MOVED")
				$"../../ShowStage".frame = 2 
