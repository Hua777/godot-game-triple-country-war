extends Node

var dialog_box_tscn = preload("res://Components/dialog_box.tscn")

func show_dialoig(text: String, animate: bool):
  var dialog = dialog_box_tscn.instantiate()
  dialog.text = text
  dialog.animate = animate
  get_viewport().add_child(dialog)
