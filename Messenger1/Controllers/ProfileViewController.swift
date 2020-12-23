//
//  ProfileViewController.swift
//  Messenger1
//
//  Created by sang1 on 03/12/2020.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
class ProfileViewController: UIViewController {
    @IBOutlet var tableView:UITableView!
    let data = ["Log out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
 
    }
        
}
extension ProfileViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let acctionSheet = UIAlertController(title: "",
                                             message: "",
                                             preferredStyle: .actionSheet)
        acctionSheet.addAction(UIAlertAction(title: "Log out",
                                             style: .destructive,
                                             handler: { [weak self] _ in
                                                guard let strongSelf = self else {
                                                    return
                                                }
                                                //log out facebook
                                                FBSDKLoginKit.LoginManager().logOut()
                                                //google log out
                                                GIDSignIn.sharedInstance()?.signOut()
                                                
                                                
                                                do { try FirebaseAuth.Auth.auth().signOut()
                                                    let vc = LoginViewController()
                                                    let nav = UINavigationController(rootViewController: vc)
                                                    nav.modalPresentationStyle = .fullScreen
                                                    strongSelf.present(nav, animated: true)// aniemate scroll up!
                                                }
                                                
                                                catch {
                                                    print("Failed to log out")
                                                }
                                             }))
        acctionSheet.addAction(UIAlertAction(title: "CanCel",
                                             style: .cancel,
                                             handler: nil))
        present(acctionSheet,animated: true)
    }
}
    

