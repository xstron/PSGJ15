extends Area2D
class_name InteractionComponent

signal interaction_signal

@export var interaction_icon: Node2D

func interact():
	interaction_signal.emit()


func icon_show():
	interaction_icon.visible = true


func icon_hide():
	interaction_icon.visible = false
