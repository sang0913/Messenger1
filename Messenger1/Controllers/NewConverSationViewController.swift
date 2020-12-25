//
//  NewConverSationViewController.swift
//  Messenger1
//
//  Created by sang1 on 03/12/2020.
//

import UIKit
import JGProgressHUD
class NewConverSationViewController: UIViewController {
    
    let spinner = JGProgressHUD()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users..."
        return searchBar
    }()
    private let tableView:UITableView = {
        let table = UITableView()
        table.isHidden = true
        
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noResulfLable:UILabel = {
       let lable = UILabel()
        lable.text = "No Result"
        lable.isHidden = true
        lable.textAlignment = .center
        lable.textColor = .green
        lable.font = .systemFont(ofSize: 21 , weight: .medium)
        return lable
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didmissSelf))
    }
    @objc private func didmissSelf () {
        dismiss(animated: true, completion: nil)
    }
    

   

}
extension NewConverSationViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        ///
    }
    
}
