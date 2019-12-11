//
//  RepositoryFileCell.swift
//  GithubAPI_Example
//
//  Created by Serhii Londar on 3/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

protocol RepositoryFileCellDelegate: class {
    func deleteButtonPressed(_ cell: RepositoryFileCell)
}

class RepositoryFileCell: UITableViewCell {
    weak var delegate: RepositoryFileCellDelegate? = nil
    @IBOutlet var icon: UIImageView!
    @IBOutlet var label: UILabel!

    @IBOutlet weak var repoLabel: UILabel!
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.deleteButtonPressed(self)
    }
}
