//
//  RepositoryVC.swift
//  GithubAPI_Example
//
//  Created by Serhii Londar on 2/28/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import GithubAPI

class RepositoryVC: UIViewController, UISearchBarDelegate {
    var token: String! = nil
    var repositoryOwner: String = "tiejiawusheng"
    var repositoryName: String = "Sol"
    
    var loginVC: GithubLoginVC?
    var contentsAPI: RepositoriesContentsAPI!
    var searchContentsAPI: SearchAPI!
    var defaultContentAPI: UserAPI!
    
    var files: [RepositoryContentsReponse] = []
    var path: String = ""
    
    var files1 : [SearchUsersItem] = []
    var files2 : [AllUsersResponse] = []
    
    var DefaultStatus:Bool = true
    var RepositoryCount:Int = 0

    @IBOutlet var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if token == nil {
            self.login()
        } else {
            self.getDefaultContent()
            navigationItem.titleView = searchBar
            searchBar.showsScopeBar = false
        }
    }
    
    func login() {
        self.loginVC =  GithubLoginVC(clientID: "3d0cddc4c11eef320d1a", clientSecret: "a01e7ac8c83e038705d338ad838595d1177444e3", redirectURL: "https://github.com/tiejiawusheng/Sol")
        self.loginVC?.login(withScopes: [Scopes.notifications], allowSignup: true, completion: { accessToken in
            self.token = accessToken
            self.getDefaultContent()
        }, error: { error in
            print(error.localizedDescription)
        })
    }
    
    func getDefaultContent(){
        DefaultStatus = true
        self.files2.removeAll()
        
        let tokenAuthentication = TokenAuthentication(token: token)
        self.defaultContentAPI = UserAPI(authentication: tokenAuthentication)
        self.defaultContentAPI.getAllUsers(since: "1") { (response, error) in
            self.files2 = response ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func getUserContent(_ userName: String) {
        DefaultStatus = false
        self.files1.removeAll()
        
        let tokenAuthentication = TokenAuthentication(token: token)
        self.searchContentsAPI = SearchAPI(authentication: tokenAuthentication)
        self.searchContentsAPI.searchUsers(q: userName) { (response, error) in
            self.files1 = response?.items ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    

    // Search Bar
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.lowercased() == ""  {
            
            self.getDefaultContent()
            
        }   else {
            
            self.getUserContent(searchText.lowercased())
            
        }
        self.tableView.reloadData()
    }
       
       func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            self.tableView.reloadData()
       }
    
    static func instantiateVC(with repositoryOwner: String, repositoryName: String) -> RepositoryVC {
        let storyboard = UIStoryboard(name: "RepositoryVC", bundle: nil)
        let repositoryVC = storyboard.instantiateViewController(withIdentifier: "RepositoryVC") as! RepositoryVC
        repositoryVC.repositoryOwner = repositoryOwner
        repositoryVC.repositoryName = repositoryName
        return repositoryVC
    }
    
    static func instantiateVC(with token: String, repositoryOwner: String, repositoryName: String) -> RepositoryVC {
        let storyboard = UIStoryboard(name: "RepositoryVC", bundle: nil)
        let repositoryVC = storyboard.instantiateViewController(withIdentifier: "RepositoryVC") as! RepositoryVC
        repositoryVC.token = token
        repositoryVC.repositoryOwner = repositoryOwner
        repositoryVC.repositoryName = repositoryName
        return repositoryVC
    }
}

extension RepositoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DefaultStatus {
            return self.files2.count
        } else {
            return self.files1.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryFileCell") as! RepositoryFileCell
        if !DefaultStatus{
            let file = self.files1[indexPath.row]//self.files[indexPath.row]
            cell.label.text = file.login!
            cell.icon.downloadFrom(link: file.avatarUrl, contentMode: UIView.ContentMode.scaleAspectFit)
//            let count = getRepositoryCount(file.reposUrl ?? "")
//            cell.repoLabel.text = "Repos : " + String(count)
        }else {
            let file = self.files2[indexPath.row]
            cell.label.text = file.login!
            cell.icon.downloadFrom(link: file.avatarUrl, contentMode: UIView.ContentMode.scaleAspectFit)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "RepositoryFileVC", bundle: nil)
        let repositoryFileVC = storyboard.instantiateViewController(withIdentifier: "RepositoryFileVC") as! RepositoryFileVC
        repositoryFileVC.token = token
        
        if DefaultStatus
        {
            let file2 = self.files2[indexPath.row]
            repositoryFileVC.userNameLogin = file2.login
        } else {
            let file1 = self.files1[indexPath.row]
            repositoryFileVC.userNameLogin = file1.login
        }
        self.navigationController?.pushViewController(repositoryFileVC, animated: true)
	}
}


extension RepositoryVC: RepositoryFileCellDelegate {
    func deleteButtonPressed(_ cell: RepositoryFileCell) {
        self.contentsAPI.deleteFile(owner: repositoryOwner, repo: repositoryName, path: "", message: "Remove file", sha: "") { (resposne, error) in
            
        }
    }
}
