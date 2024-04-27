extends Panel

signal pressed(player_head)
signal kick_out(player_head)

@onready var you_label = $"Margin外包/有玩家外包堆叠/顶部堆叠/Label你"
@onready var master_label = $"Margin外包/有玩家外包堆叠/顶部堆叠/Label房主"
@onready var checked_label = $"Margin外包/有玩家外包堆叠/顶部堆叠/Label准备好了"
@onready var user_name_label = $"Margin外包/有玩家外包堆叠/Label玩家名"
@onready var no_user_wrapper = $"Margin外包/没有玩家外包堆叠"
@onready var user_wrapper = $"Margin外包/有玩家外包堆叠"
@onready var kick_out_button = $"Margin外包/有玩家外包堆叠/顶部堆叠/Button踢开"

@export var index: int = -1

var joined: bool:
  set(value):
    joined = value
    if joined:
      no_user_wrapper.hide()
      user_wrapper.show()
    else:
      no_user_wrapper.show()
      user_wrapper.hide()

var you: bool:
  set(value):
    you = value
    if you:
      you_label.show()
    else:
      you_label.hide()

var master: bool:
  set(value):
    master = value
    if master:
      master_label.show()
    else:
      master_label.hide()

var checked: bool:
  set(value):
    checked = value
    if checked:
      checked_label.show()
    else:
      checked_label.hide()

var user_name: String:
  set(value):
    user_name = value
    user_name_label.text = user_name

var can_kick_out: bool:
  set(value):
    can_kick_out = value
    if can_kick_out:
      kick_out_button.show()
    else:
      kick_out_button.hide()

var bag = null

func _on_gui_input(event: InputEvent) -> void:
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false:
    var position = event.position
    if Rect2(0, 0, size.x, size.y).has_point(position):
      emit_signal("pressed", self)

func clear():
  joined = false
  you = false
  master = false
  checked = false
  user_name = ''
  bag = null

func _on_ready() -> void:
  clear()

func _on_kick_out_button_pressed() -> void:
  emit_signal("kick_out", self)
