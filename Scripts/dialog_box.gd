extends Control

@onready var label: RichTextLabel = $"ColorRect/MarginContainer/ColorRect/MarginContainer/VBoxContainer/文本框"
@onready var ok_button: Button = $"ColorRect/MarginContainer/ColorRect/MarginContainer/VBoxContainer/确认按钮"

@export var text: String = ''
@export var animate: bool = false

var tween: Tween = null
var can_close: bool = false

func _on_ready() -> void:
  label.text = text
  if animate:
    label.visible_ratio = 0
    tween = get_tree().create_tween()
    tween.tween_property(label, "visible_ratio", 1, 1)
    tween.tween_callback(when_full_show)
  else:
    label.visible_ratio = 1
    can_close = true

func when_full_show():
  can_close = true
  tween.kill()

func _on_ok_pressed() -> void:
  if can_close:
    queue_free()
