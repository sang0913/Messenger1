//
//  LoginViewController.swift
//  Messenger1
//
//  Created by sang1 on 03/12/2020.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn
import JGProgressHUD
class LoginViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)
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
    private let facebookLoginButton :FBLoginButton = {
        let button  = FBLoginButton()
        button.permissions = ["email,public_profile"]
        return button
    }()
    
    
        private let googleLoginButton = GIDSignInButton()
    
    private var loginObserve : NSObjectProtocol?
    
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginObserve = NotificationCenter.default.addObserver(forName: Notification.Name.didLoginNotification,object: nil,queue: .main,
                                                              using: { [weak self] _ in
                                                                guard let strongSelf  = self else {
                                                                    return
                                                                }
                                                                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                                                                
                                                              })
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        
        
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
        facebookLoginButton.delegate = self
        //add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(PassWordField)
        scrollView.addSubview(logginButton)

        scrollView.addSubview(facebookLoginButton)
        scrollView.addSubview(googleLoginButton)
    }
    deinit {
        if let observer = loginObserve {
            NotificationCenter.default.removeObserver(observer)
        }
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
        facebookLoginButton.frame = CGRect(x:30,
                                  y: logginButton.bottom + 10 ,
                                  width: scrollView.width - 60,
                                 height: 52)
        googleLoginButton.frame = CGRect(x:30,
                                  y: facebookLoginButton.bottom + 10 ,
                                  width: scrollView.width - 60,
                                 height: 52)
        
        
            
        
        
    }
    

    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Tạo Tài Khoản"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc private func loginButtonTapped () {
        emailField.resignFirstResponder()
        PassWordField.resignFirstResponder()
        guard let email = emailField.text, let password = PassWordField.text,
              !email.isEmpty, !password.isEmpty,password.count >= 6 else {
            
            alertButtonTapped ()
            return
        }
        
        
        spinner.show(in: view)
        //firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] authResult , error in
            guard let strongSelf = self else {
                return
                
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }

            guard let result = authResult,error == nil else {
                print("Failed to log in with email :\(email)")
                return
            }
            let user = result.user
            print("Loged in with user \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func alertButtonTapped () {
        
        let alert = UIAlertController(title: "Woops!!!!",
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
extension LoginViewController:LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("user failed to login with facebook")
            return
        }
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "Me",
                                                         parameters: ["fields" : "email , first_name,last_name, picture.type(large)"]
                                                         , tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        facebookRequest.start(completionHandler: { connection , result , error in
            guard let result = result as? [String: Any],
                  error == nil else
            {
                print("Failed to make face book graph request")
                return
            }
            print(result)
            
            
            guard let firstName = result["first_name"] as? String,
                  let lastName = result["last_name"] as? String,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String : Any],
                  let data = picture["data"] as? [String: Any],
                  let pictureUrl = data["url"] as? String
                  else {
                print("Failed to get email and name from fb result")
                return
            }
            
            
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    let chatUser = ChatAPpUser(firstName: firstName,
                                               lastName: lastName,
                                               emailAddress: email)
                    DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                        if success {
                            guard let url = URL(string: pictureUrl) else {
                                return
                            }
                            print("Downloading data from facebook image")
                            //upload picture
                            URLSession.shared.dataTask(with: url, completionHandler:{ data, _,_ in
                                guard let data = data else {
                                    print("Failed to get data from facebook")
                                    return
                                }
                                print("got data from FB,uploading...")
                                let fileName = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilepicture(with: data,
                                                                           fileName: fileName,
                                                                           completion: { result in
                                                                            switch result {
                                                                            case .success(let downloadUrl):
                                                                                UserDefaults.standard.setValue(downloadUrl, forKey: "profile_picture_url")
                                                                                print(downloadUrl)
                                                                            case .failure(let error) :
                                                                                print("Storage manager error:\(error)")
                                                                            }
                                                                           })
                            }).resume()
                        }
                      
                        //
                    })
                    
                }
            
            })
        
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential,
                                            completion: { [weak self]
                                                authResult , error in
                                                guard let strongSelf = self else {
                                                    return
                                                }
                                                
                                                guard authResult != nil, error == nil else {
                                                    if let error = error {
                                                        
                                                        
                                                        print("Facebook credential login failed,MAF may be needed - \(error)")
                                                    }
                                                    return
                                                }
                                                print("Successfully logged user in")
                                                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                                            })
        })
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //no operation
        
    }
    
    
    
}
