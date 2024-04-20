extends Control

@onready var account_editor = $"最外层/右侧/Panel/Margin右侧/VBoxContainer/输入表单网格/Editor账号"
@onready var password_editor = $"最外层/右侧/Panel/Margin右侧/VBoxContainer/输入表单网格/Editor密码"

var home_tscn = preload("res://Scenes/home.tscn")

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
  SceneChanger.change_scene(home_tscn.instantiate())
