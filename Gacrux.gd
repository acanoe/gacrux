extends Control

func load_feeds() -> Dictionary:
	var f := File.new()
	if f.file_exists("res://feeds.json"):
		f.open("res://feeds.json", File.READ)
		var result := JSON.parse(f.get_as_text())
		f.close()

		if result.error:
			printerr("Failed to parse feeds file: ", f.error_string)
		return result.result as Dictionary
	else:
		return {
			"urls": [
				"http://rss.cnn.com/rss/edition.rss"
			]
		}

func save_feeds(data: Dictionary):
	var f := File.new()
	f.open("res://feeds.json", File.WRITE)
	prints("Saving to", f.get_path_absolute())
	f.store_string(JSON.print(data))
	f.close()

# Called when the node enters the scene tree for the first time.
func _ready():
	var data = load_feeds()
	
	for url in data.urls:
		$RSSReader/VBoxContainer/Feeds.add_item(url, null, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
