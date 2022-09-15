//
//  NewSkillViewController.swift
//  SkillArchive
//
//  Created by student on 5/24/21.
//

/*
 some code copied from tutorial for importing photos
 https://www.hackingwithswift.com/read/10/4/importing-photos-with-uiimagepickercontroller
 */

import UIKit

// also used to edit existing skills
class NewSkillViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {

    var imageName: String = ""
    
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        
        // if editSkill is -1, it is a new skill
        // this sets the fields to their existing values if editing existing skill
        if skillID != nil {
            let path = getDocumentsDirectory().appendingPathComponent(skills[skillID!].image)
            doneButton.isEnabled = true
            coverImage.image = UIImage(contentsOfFile: path.path)
            titleTextField.text = skills[skillID!].title
            imageName = skills[skillID!].image
            //add videos and notes as I implement them
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // doneButton is enabled only when a title is set
        if textField.text != "" && textField.text != nil {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
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
        // if creating a new skill, add to skills list
        if skillID == nil {
            let newSkill = Skill(title: titleTextField.text!, image: imageName, note: "", video: "")
            //skills.append(s)
            //insert new skill into database
            do {
                try db!.insertSkill(skill: newSkill)} catch {
                print("Insertion failed.")
            }
        // if editing existing skills, make sure all fields are updated
        } else {
            skills[skillID!].title = titleTextField.text!
            skills[skillID!].image = imageName
            //add videos and notes as I implement them
            skillID = nil
        }
    }
    
}
