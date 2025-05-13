//
//  Helper.swift
//  ProfileSettings
//
//  Created by Кирилл Сысоев on 10.05.2025.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

let storyboard = UIStoryboard(name: "Main", bundle: nil)
let authVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabBarVC") as! UITabBarController

let db = Database.database().reference()

func loadImage() -> UIImage {
    guard let uid = Auth.auth().currentUser?.uid else { return UIImage(systemName: "person.crop.circle")! }
    guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage(systemName: "person.crop.circle")! }
    
    let path = directory.appendingPathComponent("profileImage-\(uid).png")
    if FileManager.default.fileExists(atPath: path.path),
       let data = try? Data(contentsOf: path),
       let image = UIImage(data: data) {
        return image
    }
    return UIImage(systemName: "person.crop.circle")!
}



extension String {
    func localized() -> String {
        NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}
