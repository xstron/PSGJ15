extends Area2D
class_name InteractionComponent

@export var interaction_icon: Node2D
@export var msg: String

func interact():
	print(msg)


func icon_show():
	interaction_icon.visible = true


func icon_hide():
	interaction_icon.visible = false
