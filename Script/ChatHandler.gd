extends CanvasLayer

@export var message: LineEdit 
@export var messages: TextEdit 
@export var send: Button 

func _on_send_pressed() -> void:
	if message.text != "":
		rpc("msg_rpc", PlayerInfo.usrnm, message.text)  # Envia nome e mensagem
		messages.scroll_vertical = INF
		message.release_focus()
		message.text = ""

@rpc("any_peer", "call_local")
func msg_rpc(username: String, data: String):
	messages.text += "[%s]: %s\n" % [username, data]
