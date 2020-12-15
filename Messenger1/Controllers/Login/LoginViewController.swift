//
//  LoginViewController.swift
//  Messenger1
//
//  Created by sang1 on 03/12/2020.
//

import UIKit
//
class LoginViewController: UIViewController {
    private let scrollView :UIScrollView = {
        let scrollView = UIScrollView ()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    //Tạo Logo
    private let imageView : UIImageView = {
        let imageView = UIImageView ()
        imageView.image = UIImage(named: "logomoney")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        button.setTitle("Đăng nhập", for: .normal)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Đăng ký",
                                                            style: .done,
                                                            target:self,
                                                            action: #selector(didTapRegister))
        logginButton.addTarget(self,
                               action: #selector(loginButtonTapped)
                               , for: .touchUpInside)
    
                                                            
                                                            
        
        emailField.delegate = self
        PassWordField.delegate = self
        //add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(PassWordField)
        scrollView.addSubview(logginButton)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x:(scrollView.width - size) / 2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x:30,
                                  y: imageView.bottom + 10 ,
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
        
        guard let email = emailField.text, let password = PassWordField.text,
              !email.isEmpty, !password.isEmpty,password.count >= 6 else {
            
            alertButtonTapped ()
            return
        }
    }
  
    func alertButtonTapped () {
        
        let alert = UIAlertController(title: "Notice!!!!",
                                      message: "Please inter your information to log in",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert,animated: true)
    }

    
    
    
}
    extension LoginViewController: UITextFieldDelegate {
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
