extends Node

func format_message(message: String) -> String:
	var dt := OS.get_datetime()

	# Formated message
	return str("%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second], message)

func error(error_message: String):
	var message := format_message(error_message)
	push_error(message)
