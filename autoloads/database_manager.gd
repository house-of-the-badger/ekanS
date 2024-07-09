extends Node

const COLLECTION_NAME_PLAYERS = "players"

signal firestore_error(code, status, message)
signal player_data_changed(data: Dictionary)

func _ready():
	var firestore = Firebase.Firestore
	firestore.connect("error", Callable(self, "_on_firestore_error"))

func _on_firestore_error(code, status, message):
	emit_signal("firestore_error", code, status, message)
	print("Firestore error:", code, status, message)
	
func create_empty_player_document(user_id: String) -> void:
	var firestore_collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_NAME_PLAYERS)
	var data: Dictionary = {
		"username": "",
		"avatar_id": 0,
		"avatar_img": "",
		"score": 0  # Assuming score is an integer
	}  # Empty dictionary for creating an empty document
	var document = await firestore_collection.add(user_id, data)
	print(document)
	
	if document:
		print("Empty document created for user:", user_id)
		print(document)
	else:
		print("Failed to create document for user:", user_id)

func save_score(user_id: String, score: int) -> void:
	var firestore_collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_NAME_PLAYERS)
	var document = await firestore_collection.get_doc(user_id)
	if document and not document.is_null_value("score"):
		print("Updating existing score")
		document.add_or_update_field("score", score)
		await firestore_collection.update(document)
	else:
		print("Creating new document with score")
		var data: Dictionary = {
			"score": score
		}
		document = await firestore_collection.add(user_id, data)
		print("Document created with ID: ", document.doc_name)
		
func update_player_data(user_id: String, username: String, avatar_id: int, avatar_img: String, avatar_color:String) -> void:
	var firestore_collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_NAME_PLAYERS)
	print(firestore_collection, "collection in database manager")
	var document = await firestore_collection.get_doc(user_id)
	print(document, "document in database manager")
	if document:
		print("Updating document for user:", user_id)
		document.add_or_update_field("username", username)
		document.add_or_update_field("avatar_id", avatar_id)
		document.add_or_update_field("avatar_img", avatar_img)
		document.add_or_update_field("avatar_color", avatar_color)
		var updated_document = await firestore_collection.update(document)
		print("Updated document:", updated_document)
	else:
		print("Error: Document not found for user:", user_id)

func get_player_data(user_id: String):
	print("database manager Fetching player data for user:", user_id)
	var firestore_collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_NAME_PLAYERS)
	var document = await firestore_collection.get_doc(user_id, false, true)
	if document:
		print("database manager Document fetched successfully:", document.document)
		player_data_changed.emit(document.document)
	else:
		print("Error: Document not found for user:", user_id)

