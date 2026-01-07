extends Area2D

var item_array: Array[Item] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pickup_item():
	print("OH YEA: " + str(item_array))
	if(item_array.size() > 0):
		var ps : Player = get_parent()
		item_array[0].pickup(ps)

func _on_area_entered(area: Area2D) -> void:
	item_array.append(area.get_parent())
	print(item_array)

func _on_area_exited(area: Area2D) -> void:
	var _index = item_array.find(area.get_parent())
	if(_index != -1):
		item_array.remove_at(_index)
		print(item_array)

func _on_body_entered(body: Node2D) -> void:
	item_array.append(body)
	print(item_array)


func _on_body_exited(body: Node2D) -> void:
	var _index = item_array.find(body)
	if(_index != -1):
		item_array.remove_at(_index)
		print(item_array)
