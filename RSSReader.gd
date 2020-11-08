extends Panel

var title_arr = []
var link_arr = []
var detais_arr = []

func _on_Add_pressed():
	pass

func _on_Open_pressed():
	OS.shell_open($VBoxContainer/HBoxContainer/Url.text)

func _on_Feeds_item_selected(index):
	$VBoxContainer/AppBar/Status.set_text("Loading feed items....")
	
	var url =$VBoxContainer/Feeds.get_item_text(index)
	$HTTPRequest.request(url)

func _on_News_item_selected(index):
	$VBoxContainer/HBoxContainer/Url.set_text(link_arr[index])
	$VBoxContainer/HBoxContainer/Open.visible = true

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	$VBoxContainer/AppBar/Status.set_text("All items loaded")

	var p = XMLParser.new()
	var in_item_node = false
	var in_title_node = false
	var in_description_node = false
	var in_link_node = false

	p.open_buffer(body)

	while p.read() == OK:
		var node_name = p.get_node_name()
		var node_data = p.get_node_data()
		var node_type = p.get_node_type()

		if(node_name == "item"):
			in_item_node = !in_item_node #toggle item mode

		if (node_name == "title") and (in_item_node == true):
			in_title_node = !in_title_node
			continue

		if(node_name == "description") and (in_item_node == true):
			in_description_node = !in_description_node
			continue

		if(node_name == "link") and (in_item_node == true):
			in_link_node = !in_link_node
			continue

		if(in_description_node == true):
			# print("description-data" + node_data)
			if(node_data != ""):
				detais_arr.append(node_data)
			else:
				# print("description:" + node_name)
				detais_arr.append(node_name)

		if(in_title_node == true):
			# print("Title-data:"+ node_data)
			if(node_data !=""):
				title_arr.append(node_data)
			else:
				# print("Title:" + node_name)
				title_arr.append(node_name)

		if(in_link_node == true):
			# print("link-desc" + node_data)
			if(node_data != ""):
				link_arr.append(node_data)
			else:
				# print("link" + node_name)
				link_arr.append(node_name)
	
	for item in title_arr:
		$VBoxContainer/News.add_item(item, null, true)

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
