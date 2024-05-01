extends Node

var room_master: bool:
  set(value):
    room_master = value
    if room_master:
      start_button.text = '开始游戏'
      loyal_count_editor.editable = true
      traitor_count_editor.editable = true
      rebel_count_editor.editable = true
    else:
      if is_ready:
        start_button.text = '取消准备'
      else:
        start_button.text = '准备'
      loyal_count_editor.editable = false
      traitor_count_editor.editable = false
      rebel_count_editor.editable = false

var room_id: String

var is_ready: bool:
  set(value):
    is_ready = value
    if room_master:
      start_button.text = '开始游戏'
    else:
      if is_ready:
        start_button.text = '取消准备'
      else:
        start_button.text = '准备'

@onready var room_name_label = $"房间表单/外包/堆叠/上层堆叠/Label房间名"
@onready var loyal_count_editor = $"房间表单/外包/堆叠/下层堆叠/Margin控制器/VBoxContainer/Grid身份设置/Editor忠臣数量"
@onready var traitor_count_editor = $"房间表单/外包/堆叠/下层堆叠/Margin控制器/VBoxContainer/Grid身份设置/Editor内奸数量"
@onready var rebel_count_editor = $"房间表单/外包/堆叠/下层堆叠/Margin控制器/VBoxContainer/Grid身份设置/Editor反贼数量"

@onready var start_button = $"房间表单/外包/堆叠/下层堆叠/Margin控制器/VBoxContainer/Button开始游戏"

@onready var grid_players = $"房间表单/外包/堆叠/下层堆叠/Grid玩家们"

func _on_ready() -> void:
  TcwbSocket.connect("room_info", Callable(self, "_on_room_info_finished"))
  TcwbSocket.connect("you_leave_room", Callable(self, "_on_you_leave_room_finished"))
  TcwbSocket.connect("you_kick_out_user_from_room", Callable(self, "_on_you_kick_out_user_from_room_finished"))
  TcwbSocket.connect("someone_join_room", Callable(self, "_on_someone_join_room_finished"))
  TcwbSocket.connect("someone_leave_room", Callable(self, "_on_someone_leave_room_finished"))
  TcwbSocket.connect("you_kicked_out", Callable(self, "_on_you_kicked_out_finished"))
  TcwbSocket.connect("room_property_changed", Callable(self, "_on_room_property_changed_finished"))
  TcwbSocket.connect("user_ready_changed", Callable(self, "_on_user_ready_changed_finished"))
  TcwbSocket.connect("game_started", Callable(self, "_on_game_started_finished"))
  room_master = false
  TcwbSocket.request_room_info()

func _on_room_info_finished(info):
  # 获取房主账号
  var master_account = info['room']['master_account']

  # 房间名
  room_name_label.text = info['room']['name']

  # 设置当前房间你是不是房主
  room_master = Global.user_info['account'] == master_account

  # 清空每个用户 UI
  var player_uis = grid_players.get_children()
  for player_ui in player_uis:
    player_ui.clear()

  # 重新设置每个用户的 UI
  var idx = 0
  for account in info['users']:
    player_uis[idx].joined = true
    player_uis[idx].you = Global.user_info['account'] == account
    player_uis[idx].room_master = account == master_account
    player_uis[idx].can_kick_out = Global.user_info['account'] == master_account and account != Global.user_info['account']
    player_uis[idx].user_name = info['users'][account]['username']
    player_uis[idx].is_ready = info['users'][account]['ready']
    player_uis[idx].bag = info['users'][account]

    # 给自己刷新准备状态
    if player_uis[idx].you:
      is_ready = player_uis[idx].is_ready

    idx += 1

  # 忠臣数量
  loyal_count_editor.text = str(info['room']['loyal_count'])

  # 内奸数量
  traitor_count_editor.text = str(info['room']['traitor_count'])

  # 反贼数量
  rebel_count_editor.text = str(info['room']['rebel_count'])

func _on_room_leave_button_pressed() -> void:
  TcwbSocket.request_leave_room()

func _on_you_leave_room_finished(info):
  SceneChanger.back_scene()

func _on_user_player_pressed(player_head) -> void:
  pass

func _on_user_player_kick_out(player_head) -> void:
  TcwbSocket.request_kick_out_room(player_head.bag.account)

func _on_you_kick_out_user_from_room_finished(info):
  pass

func _on_someone_join_room_finished(info):
  TcwbSocket.request_room_info()

func _on_someone_leave_room_finished(info):
  TcwbSocket.request_room_info()

func _on_you_kicked_out_finished(info):
  DialogTool.show_dialoig('你已被房主踢出房间', false)
  SceneChanger.back_scene()

func _on_user_ready_changed_finished(info):
  TcwbSocket.request_room_info()

func _on_game_started_finished(info):
  TcwbSocket.request_room_info()

func _on_start_pressed() -> void:
  if room_master:
    TcwbSocket.request_start_game()
  else:
    is_ready = not is_ready
    TcwbSocket.request_ready_or_not()

func _on_editor忠臣数量_text_changed(new_text: String) -> void:
  TcwbSocket.request_change_room_property(loyal_count_editor.text, traitor_count_editor.text, rebel_count_editor.text)

func _on_editor内奸数量_text_changed(new_text: String) -> void:
  TcwbSocket.request_change_room_property(loyal_count_editor.text, traitor_count_editor.text, rebel_count_editor.text)

func _on_editor反贼数量_text_changed(new_text: String) -> void:
  TcwbSocket.request_change_room_property(loyal_count_editor.text, traitor_count_editor.text, rebel_count_editor.text)

func _on_room_property_changed_finished(info):
  if not room_master:
    TcwbSocket.request_room_info()
