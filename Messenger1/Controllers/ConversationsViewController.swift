//
//  ViewController.swift
//  Messenger1
//
//  Created by sang1 on 02/12/2020.
//

import UIKit

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
    if !isLoggedIn {
    let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)// aniemate scroll up!
    }
    }

}

