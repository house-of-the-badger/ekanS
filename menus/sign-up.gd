class_name SignUp extends Control


# Called when the node enters the scene tree for the first time.
func _ready(): 
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(on_signup_failed)

func _on_sign_up_button_pressed():
	var email = %EmailInput.text
	var password = %PasswordInput.text
	var confirm_password = %PasswrodInput2.text
	if(password == confirm_password):
		Firebase.Auth.signup_with_email_and_password(email, password)
		%SignupStateLabel.text = "Creating account..."
	else:
		%SignupStateLabel.text = "Password don't match"

func on_signup_succeeded(auth):
	print(auth)
	%SignupStateLabel.text= "Account created!"
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_file("res://menus/Avatar_selection.tscn")
	
func on_signup_failed(error_code, message):
	print(error_code)
	print(message)
	%SignupStateLabel.text = "%s" % message

func _on_login_button_pressed():
	get_tree().change_scene_to_file("res://menus/Login.tscn")
