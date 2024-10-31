extends Node3D

@onready var menu: CanvasLayer = $Menu
@onready var chat: CanvasLayer = $Chat
@onready var line_edit: LineEdit = $Menu/Panel/PanelContainer/MarginContainer/VBoxContainer/LineEdit

@export var player_scene : PackedScene

var peer = ENetMultiplayerPeer.new()

func _on_host_pressed() -> void:
	menu.hide()
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(joined)
	joined()

func _on_join_pressed() -> void:
	menu.hide()
	peer.create_client(line_edit.text, 1027)
	multiplayer.multiplayer_peer = peer

func joined(id = multiplayer.get_unique_id()):
	var player = player_scene.instantiate()
	player.name = str(id)
	
	call_deferred("add_child", player)
