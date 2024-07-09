extends Node

const COLLECTION_NAME_PLAYERS = "players"

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
