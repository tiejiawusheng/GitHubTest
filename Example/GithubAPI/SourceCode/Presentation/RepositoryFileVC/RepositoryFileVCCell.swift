//
//  RepositoryFileVCCell.swift
//  GithubAPI_Example
//
//  Created by mawenbo on 12/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class RepositoryFileVCCell: UITableViewCell {
    
    weak var delegate: RepositoryFileCellDelegate? = nil
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var forksLabel: UILabel!
    
    @IBOutlet weak var starsLabel: UILabel!
    
    
}
