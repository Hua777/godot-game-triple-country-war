extends Node

var user_info: Dictionary = {}

func get_user_id() -> String:
  if 'user_id' in user_info:
    return user_info['user_id']
  return ''
