//
//  ViewController.swift
//  Messenger1
//
//  Created by sang1 on 02/12/2020.
//

import UIKit
import FirebaseAuth
class ConversationsViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView()
        
        return table
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        
//        DatabaseManager.shared.test()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    validateAuth()
   
       
    }
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
    let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)// aniemate scroll up!
    }
    }
}

