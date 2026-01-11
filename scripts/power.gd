extends Label

var power : float = 100.0
var usage : int = 1  # Starts at 1 (Fan is always on)

const DRAIN_RATES = {
	1: 0.15, # Usage 1 (Just Fan) ~11 minutes to drain
	2: 0.40, # Usage 2 (Fan + Camera)
	3: 0.70, # Usage 3 (Fan + Door + Camera)
	4: 1.00, # Usage 4 (FAN + 2Dorr + Cam)
}


func _process(delta: float) -> void:
	# If power is already out, do nothing
	if power <= 0:
		return 
		
	calculate_usage()
	
	# --- DRAIN POWER ---
	# Get the drain rate for current usage (default to max if usage > 4)
	var current_rate = DRAIN_RATES.get(clamp(usage, 1, 4), 1)
	
	power -= current_rate * delta
	
	# --- UPDATE UI ---
	text = "Power left: " + str(int(power)) + "%"
	
	# Optional: Update Usage Bar Visuals if you have them
	update_usage_visuals() 
	
	# --- CHECK POWER OUTAGE ---
	if power <= 0:
		power = 0
		text = "Power left: 0%"
		visible = false
		$"../../LightOut".lightout()
		if $"../cambutton".camstate == -1:
				# Hide the UI immediately
			$"../static".visible = false
			$"../whiterect".visible = false
			$"../RedDot".visible = false
			$"../map".visible = false
			$"../static2".visible = false
			$"../static2/static sound".stop()
			
			if $"../map".active_sprite != null:
				$"../map".active_sprite.visible = false
				if $"../map".active_sprite == $"../../kitchen":
					$"../kitchentext".visible = false
				$"../../easthallcorneranimation".visible = false
			
			$"../CameraFlip".visible = true
			$"../CameraFlip".play_backwards()
			$"../CameraFlip/flipnoise".play()
			await $"../CameraFlip".animation_finished
			$"../CameraFlip".visible = false
			$"../CameraFlip/flipnoise".stop()

func calculate_usage() -> void:
	usage = 1 # Reset to 1 (Fan is always running)
	
	if $"../../left door".frame != 0:
		usage += 1
		
	if $"../../right door".frame != 0:
		usage += 1
		
	if $"../cambutton".camstate == -1:
		usage += 1
		
	# 4. Check Lights
	# A reliable way is checking if the light sound is playing, or checking the office frame
	if $"../../left switch/light noise".playing:
		usage += 1
	if $"../../right switch/light noise".playing:
		usage += 1

func update_usage_visuals() -> void:
	# Assuming you have a Sprite with frames 0 to 4 matching the bars
	var sprite = $powerbar
	# Usage is 1-5, frames are usually 0-3
	sprite.frame = clamp(usage - 1, 0, 3)
