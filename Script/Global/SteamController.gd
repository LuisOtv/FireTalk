extends Node

var AppID = "480"

func _init() -> void:
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Steam.steamInit()

	var SteamId = Steam.getSteamID()
	var SteamName = Steam.getFriendPersonaName(SteamId)

	var SteamIsRunning = Steam.isSteamRunning()

	if !SteamIsRunning:
		print("Steam NOT Running")
	else:
		print("Steam IS Running")
		PlayerInfo.usrnm = str(SteamName)
