//
//  EditViewController.swift
//  ProfileSettings
//
//  Created by Кирилл Сысоев on 10.05.2025.
//

import UIKit
import FirebaseAuth

class EditViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    var profileName = String()
    var profileEmail = String()
    var profileImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        imageView.image = profileImage
        nameTextField.text = profileName
        emailTextField.text = profileEmail
        
        saveChangesButton.addTarget(self, action: #selector(saveChangesButtonTapped), for: .touchUpInside)
        changeImageButton.addTarget(self, action: #selector(changeImageButtonTapped), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        
        label.text = "Kirill".localized()
    }
    
    @objc func saveChangesButtonTapped() {
        db.child("users").child("user-\(Auth.auth().currentUser!.uid)").setValue([
            "email": emailTextField.text ?? "",
            "name": nameTextField.text ?? ""
        ])
        saveImageLocally(image: imageView.image!)
        navigationController?.popViewController(animated: true)
        let alert = UIAlertController(title: "Succesfully", message: "Changes successfully saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Oк", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @objc func changeImageButtonTapped() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc func signOutButtonTapped() {
        do {
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: false)
        } catch {
            print("Ошибка: \(error)")
        }
    }
    

    func saveImageLocally(image: UIImage) {
        guard let data = image.pngData(), let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let path = directory.appendingPathComponent("profileImage-\(Auth.auth().currentUser!.uid).png")
        
        do {
            try data.write(to: path)
            
            UserDefaults.standard.set(path.path, forKey: "imagePath-\(Auth.auth().currentUser!.uid)")
        } catch {
            print("Ошибка сохранения картинки \(error)")
        }
    }

}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        imageView.image = image
        dismiss(animated: true)
    }
}

extension EditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
