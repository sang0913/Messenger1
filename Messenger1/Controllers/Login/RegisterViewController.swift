//
//  RegisterViewController.swift
//  Messenger1
//
//  Created by sang1 on 03/12/2020.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
class RegisterViewController: UIViewController, UINavigationControllerDelegate {
   
    private let spinner = JGProgressHUD(style: .dark)
    
    
    private let scrollView :UIScrollView = {
        let scrollView = UIScrollView ()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    //Tạo Logo
    private let imageView : UIImageView = {
        let imageView = UIImageView ()
        imageView.image = UIImage(systemName: "heart.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
     
        imageView.tintColor = .systemPink
        return imageView
    }()
    private let FirstName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "First Name..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
        
        //tạo khung điền Passworld
    }()
    private let LastName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Last Name..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
        
        //tạo khung điền Passworld
    }()
    
    //tạo khung điền email
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
        
        //tạo khung điền Passworld
    }()
    private let PassWordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
        
    }()
    //tạo nút đăng nhập

    private let logginButton:UIButton = {
        let button = UIButton()
        button.setTitle("Đăng kí", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20,weight: .bold)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Đăng nhập"
        view.backgroundColor = .white
        //create bar button and navigation it
       
        logginButton.addTarget(self,
                               action: #selector(loginButtonTapped)
                               , for: .touchUpInside)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didtaptochangePicprofile))
        emailField.delegate = self
        PassWordField.delegate = self
        //add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(FirstName)
        scrollView.addSubview(LastName)
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.addSubview(emailField)
        scrollView.addSubview(PassWordField)
        scrollView.addSubview(logginButton)
        imageView.addGestureRecognizer(gesture)
    }
    @objc private func  didtaptochangePicprofile() {
        didtapChangePicProfile()
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x:(scrollView.width - size) / 2.0,
                                 y: 20,
                                 width: size,
                                 height: size)
 
        imageView.layer.cornerRadius = imageView.width / 2
        
     
        FirstName.frame = CGRect(x:30,
                                  y: imageView.bottom + 10 ,
                                  width: scrollView.width - 60,
                                 height: 52)
        LastName.frame = CGRect(x:30,
                                  y: FirstName.bottom + 10 ,
                                  width: scrollView.width - 60,
                                 height: 52)
        emailField.frame = CGRect(x:30,
                                  y: LastName.bottom + 10 ,
                                  width: scrollView.width - 60,
                                 height: 52)
        PassWordField.frame = CGRect(x:30,
                                  y: emailField.bottom + 10 ,
                                  width: scrollView.width - 60,
                                 height: 52)
        logginButton.frame = CGRect(x:30,
                                  y: PassWordField.bottom + 10 ,
                                  width: scrollView.width - 60,
                                 height: 52)
    }
    
    
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Tạo Tài Khoản"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc private func loginButtonTapped () {
            guard let email = emailField.text,
              let password = PassWordField.text,
              let firstName = FirstName.text,
              let lastName = LastName.text,
              !email.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
            
            alertUserLoginError ()
            return
        }
        spinner.show(in: view)
        //firebase log in
        DatabaseManager.shared.userExists(with: email, completion: {[weak self] exists in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard !exists else {
                // user already exists
                strongSelf.alertUserLoginError(message: "Look like a user account for that email address already exists"  )
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {  authResult , error in
                
                guard authResult != nil, error == nil else {
                    
                    print("Error creating user!")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: ChatAPpUser(firstName: firstName,
                                                                    lastName: lastName,
                                                                    emailAddress: email))
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
     
    }
    func alertUserLoginError (message:String = "Please inter full information to register!" ) {
        
        let alert = UIAlertController(title: "Notice!",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert,animated: true)
    }

    
    
    
}
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        if textField == emailField {
            PassWordField.becomeFirstResponder()
        }
        else if textField == PassWordField {
            loginButtonTapped()
        }
        return true
}
  
    
}
extension RegisterViewController : UIImagePickerControllerDelegate {
    
    func didtapChangePicProfile (){
        
        let acctionsheet = UIAlertController(title: "Picture profile",
                                             message: "how do you like your profile?",
                                             preferredStyle: .actionSheet)
        acctionsheet.addAction(UIAlertAction(title: "Take a photo",
                                             style: .default,
                                             handler: { [weak self]_ in
                                                self?.presentcamera()
                                             }))
        acctionsheet.addAction(UIAlertAction(title: "Choose a photo",
                                             style: .default,
                                             handler: {[weak self] _ in
                                                self?.presentphoto()
                                             }))
        acctionsheet.addAction(UIAlertAction(title: "Cancel",
                                             style: .cancel,
                                             handler: nil))
        
    
    present(acctionsheet,animated: true)
    
    
}
    
    func presentcamera() {
        let vc = UIImagePickerController()
        vc.allowsEditing = true
        vc.sourceType = .camera
        vc.delegate = self
        present(vc,animated: true)
    }
    func presentphoto() {
        let vc = UIImagePickerController()
        vc.allowsEditing = true
        vc.sourceType = .photoLibrary
        
        vc.delegate = self
        present(vc,animated: true)
    }
//    imageView.layer.cornerRadius = 2
//    imageView.layer.masksToBounds = true
//    imageView.layer.borderColor = UIColor.gray.cgColor
//    imageView.layer.cornerRadius = imageView.width / 2
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
         
        self.imageView.image = selectimage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

    
