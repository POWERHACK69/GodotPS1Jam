extends Node


func _ready():
	var joypads = Input.get_connected_joypads()
	for joypad_id in joypads:
		var name = Input.get_joy_name(joypad_id).to_lower()
		
		if "xbox" in name:
			print("Xbox controller detected. Time to spam roll dodges.")
		elif "dualshock" in name or "playstation" in name or "ps4" in name or "ps3" in name or "dualsense" in name:
			print("PlayStation controller detected. You better not be mashing square.")
		else:
			print("Unknown controller detected: ", name)
