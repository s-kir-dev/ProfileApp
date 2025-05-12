//
//  ProfileViewController.swift
//  ProfileSettings
//
//  Created by Кирилл Сысоев on 10.05.2025.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        imageView.image = loadImage()
        if let user = Auth.auth().currentUser {
            db.child("users").child("user-\(user.uid)").observeSingleEvent(of: .value, with: { snaphot in
                if let child = snaphot.value as? [String: Any], let email = child["email"] as? String, let password = child["password"] as? String {
                    self.nameLabel.text = password
                    self.emailLabel.text = email
                }
            })
        }
    }
    

    @objc func editButtonTapped() {
        performSegue(withIdentifier: "editProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfile" {
            guard let destinationVC = segue.destination as? EditViewController else { return }
            destinationVC.profileName = nameLabel.text ?? ""
            destinationVC.profileEmail = emailLabel.text ?? ""
            destinationVC.profileImage = imageView.image ?? UIImage(systemName: "person.crop.circle")!
        }
    }

}
