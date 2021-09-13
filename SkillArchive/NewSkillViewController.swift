//
//  NewSkillViewController.swift
//  SkillArchive
//
//  Created by student on 5/24/21.
//

import UIKit

class NewSkillViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {

    var imageName: String = ""
    
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        
        if editSkill != -1 {
            let path = getDocumentsDirectory().appendingPathComponent(skills[editSkill].image)
            coverImage.image = UIImage(contentsOfFile: path.path)
            titleTextField.text = skills[editSkill].title
            imageName = skills[editSkill].image
            //add videos and notes as I implement them
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func importNew() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        //set coverImage
        let path = getDocumentsDirectory().appendingPathComponent(imageName)
        coverImage.image = UIImage(contentsOfFile: path.path)
        
        dismiss(animated: true)
    }

    @IBAction func createNewSkill() {
        //if statement to check for empty fields
        if editSkill == -1 {
            let s = Skill(number: skills.count, title: titleTextField.text!, image: imageName, note: "", video: "")
            skills.append(s)
        } else {
            skills[editSkill].title = titleTextField.text!
            skills[editSkill].image = imageName
            editSkill = -1
        }
    }
    
}
