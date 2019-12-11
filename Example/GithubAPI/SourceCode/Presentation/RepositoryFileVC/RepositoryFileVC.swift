//
//  RepositoryFileVC.swift
//  GithubAPI_Example
//
//  Created by Serhii Londar on 3/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import GithubAPI

class RepositoryFileVC: UIViewController, UISearchBarDelegate {
	var path: String! = nil
	var repositoryOwner: String = "tiejiawusheng"
	var repositoryName: String = "Sol"
    var token: String! = nil
    var defaultContentAPI: UserAPI!
    var repositoriesAPI:RepositoriesAPI!
	var contentsAPI: RepositoriesContentsAPI!
    var files: [RepositoryResponse] = []
    var filiter : [RepositoryResponse] = []
    var file : OtherUserResponse!
	var sha: String? = nil
    var userNameLogin : String! = nil
 
    @IBOutlet weak var avatorImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet{
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDefaultContent()
        self.getRepositoriesContent()
        
//        navigationItem.titleView = searchBar
//        searchBar.showsScopeBar = false
        
//		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(saveFile))
//        self.displayAvatorImage()
        
    }
    
    func displayDistribute () {
        avatorImage.downloadFrom(link: file.avatarUrl, contentMode: UIView.ContentMode.scaleAspectFit)
        userNameLabel.text  = "UserName: \(String(describing: userNameLogin!))"
        emailLabel.text     = "Email: \(String(describing: file.email ?? "NO"))"
        locationLabel.text  = "Location: \(String(describing: file.location ?? "NO"))"
        joinDateLabel.text  = "JoinDate:   1980"
        followersLabel.text = "Followers: \(String(describing: file.followers!))"
        followingLabel.text = "Following: \(String(describing: file.following!))"
        
    }
    
    func getDefaultContent() {
        let tokenAuthentication = TokenAuthentication(token: token)
        self.defaultContentAPI = UserAPI(authentication: tokenAuthentication)
        self.defaultContentAPI.getUser(username: userNameLogin) { (response, error) in
            self.file = response
            
            DispatchQueue.main.async{
                self.displayDistribute()
            }
        }
    }
    
    func getRepositoriesContent () {
        let tokenAuthentication = TokenAuthentication(token: token)
        self.repositoriesAPI = RepositoriesAPI(authentication: tokenAuthentication)
        self.repositoriesAPI.repositories(user: userNameLogin) { (response, error) in
            self.files = response ?? []
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    func getSearchRepositoriesContent (reposName:String) {
        filiter.removeAll()
        for i in 0 ..< files.count {
             if (files[i].name?.contains(reposName))! {
                 filiter.append(files[i])
             }
        }
        files = filiter
    }
    
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.lowercased() == ""  {
            
            self.getRepositoriesContent()
            
        }   else {
            
            self.getSearchRepositoriesContent(reposName: searchText.lowercased())
            
        }
        self.tableView.reloadData()
    }
       
       func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            self.tableView.reloadData()
       }
}

extension RepositoryFileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryFileVCCell") as!  RepositoryFileVCCell
        
        let file = self.files[indexPath.row]
        cell.userNameLabel.text = file.name
        cell.forksLabel.text = "\(String(describing: file.forksCount!)) Forks"
        cell.starsLabel.text = "\(String(describing: file.stargazersCount!)) Stars"
        cell.delegate = self as? RepositoryFileCellDelegate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
    }
}
