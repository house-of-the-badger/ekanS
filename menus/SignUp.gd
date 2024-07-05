class_name SignUp extends Control


# Called when the node enters the scene tree for the first time.
func _ready(): 
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(on_signup_failed)
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)




func _on_sign_up_button_pressed():
	var email = %EmailInput.text
	var password = %PasswordInput.text
	var confirm_password = %PasswrodInput2.text
	if(password == confirm_password):
		Firebase.Auth.signup_with_email_and_password(email, password)
		%StateLabel.text = "Creating account..."
	else:
		%StateLabel.text = "Password don't match"

func on_signup_succeeded(auth):
	print(auth)
	%StateLabel.text= "Account created!"
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_file("res://menus/Avatar_selection.tscn")
	

func on_signup_failed(error_code, message):
	print(error_code)
	print(message)
	%StateLabel.text = "%s" % message


func _on_login_button_pressed():
	var email = %EmailInput.text
	var password = %PasswordInput.text
	Firebase.Auth.login_with_email_and_password(email, password)
	
func on_login_succeeded(auth):
	get_tree().change_scene_to_file("res://menus/Avatar_selection.tscn")
	
func on_login_failed(error_code, message):
	%StateLabel.text = "%s" % message
