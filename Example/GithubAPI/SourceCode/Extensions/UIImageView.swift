//
//  UIImageView.swift
//  GithubAPI_Example
//
//  Created by mawenbo on 12/9/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadFrom(link:String?, contentMode mode: UIView.ContentMode)
    {
        contentMode = mode
        if link == nil
        {
            self.image = UIImage(named: "default")
            return
        }
        if let url = NSURL(string: link!)
        {
            //print("\nstart download: \(url.lastPathComponent!)")
            URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, _, error) -> Void in
                guard let data = data, error == nil else {
                    //print("\nerror on download \(String(describing: error))")
                    return
                }
                DispatchQueue.main.async {
                    //print("\ndownload completed \(url.lastPathComponent!)")
                    self.image = UIImage(data: data)
                }
            }).resume()
        }
        else
        {
            self.image = UIImage(named: "default")
        }
    }
}
