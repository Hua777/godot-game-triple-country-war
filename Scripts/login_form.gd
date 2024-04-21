extends Node

@onready var account_editor = $"登录表单/最外层/右侧/Panel/VBoxContainer/输入表单网格/Editor账号"
@onready var password_editor = $"登录表单/最外层/右侧/Panel/VBoxContainer/输入表单网格/Editor密码"

var home_tscn = preload("res://Scenes/home.tscn")

func _on_ready() -> void:
  auto_login()

func auto_login():
  await get_tree().create_timer(1).timeout
  _on_login_pressed()

func _on_login_pressed() -> void:
  if account_editor.text == '' or password_editor.text == '':
    DialogTool.show_dialoig('请输入正确的账号或密码', false)
    return
  if len(account_editor.text) < 6:
    DialogTool.show_dialoig('账号必须大于 6 个字符', false)
    return
  if len(password_editor.text) < 6:
    DialogTool.show_dialoig('密码必须大于 6 个字符', false)
    return
  # TODO login
  SceneChanger.next_scene(home_tscn.instantiate())
