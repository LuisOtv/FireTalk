extends Node

func _ready():
	# Application ID
	DiscordRPC.app_id = 1204791407705849876
	# this is boolean if everything worked
	print("Discord working: " + str(DiscordRPC.get_is_discord_working()))
	 # Set the first custom text row of the activity here
	DiscordRPC.details = "Yapping"
	 # Set the second custom text row of the activity here
	DiscordRPC.large_image = "fire"
	 # Tooltip text for the large image
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	# "59:59 remaining" timestamp for the activity
	# Always refresh after changing the values!
	DiscordRPC.refresh() 
