//
//  RatingViewController.swift
//  ProfileSettings
//
//  Created by Кирилл Сысоев on 13.05.2025.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RatingViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var myRateLabel: UILabel!
    @IBOutlet weak var firstStar: UIButton!
    @IBOutlet weak var secondStar: UIButton!
    @IBOutlet weak var thirdStar: UIButton!
    @IBOutlet weak var fourthStar: UIButton!
    @IBOutlet weak var fifthStar: UIButton!
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttons = [firstStar, secondStar, thirdStar, fourthStar, fifthStar]
        
        for button in buttons {
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
        }
        
        nameTextField.delegate = self
        
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func starTapped(_ sender: UIButton) {
        if let selectedIndex = buttons.firstIndex(of: sender), let name = nameLabel.text, !name.isEmpty {
            fillStars(int: selectedIndex)
            db.child("ratings").child(name).child(Auth.auth().currentUser!.uid).setValue([
                "myRate": selectedIndex + 1
            ])
        }
    }
    
    @objc func confirmButtonTapped() {
        if let name = nameLabel.text, !name.isEmpty {
            countRating(name: name, completion: { rating in
                self.ratingLabel.text = rating
            })
            setMyRate(name: name)
        }
    }
    
    func setMyRate(name: String) {
        db.child("ratings").child(name).child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { snaphot in
            if let data = snaphot.value as? [String: Any], let myRate = data["myRate"] as? Int {
                self.myRateLabel.text! = "⭐️\(myRate)"
            }
        })
    }
    
    func fillStars(int: Int) {
        var rate = 0
        
        for (index, button) in buttons.enumerated() {
            if index <= int {
                button.setImage(UIImage(systemName: "star.fill"), for: .normal)
                rate += 1
            } else {
                button.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }

    func countRating(name: String, completion: @escaping (String) -> Void) {
        var kolvo = 0
        var summa = 0
        db.child("ratings").child(name).observeSingleEvent(of: .value, with: { snaphot in
            kolvo = Int(snaphot.childrenCount)
            let group = DispatchGroup()
            
            for child in snaphot.children {
                group.enter()
                
                if let childSnaphot = child as? DataSnapshot {
                    db.child("ratings").child(name).child(childSnaphot.key).observeSingleEvent(of: .value, with: { snaphot in
                        defer { group.leave() }
                        guard let value = childSnaphot.value as? [String: Any], let rate = value["myRate"] as? Int else { return }
                        summa += rate
                    })
                }
                
            }
            
            group.notify(queue: .main) {
                let rating = Double(summa)/Double(kolvo)
                let roundedRating = Double(rating * 100).rounded()/100
                completion("⭐️\(roundedRating)")
            }
        })
        completion("⭐️0.0")
    }

}


extension RatingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameLabel.text = textField.text
        textField.resignFirstResponder()
        return true
    }
}
