//
//  NewSkillViewController.swift
//  SkillArchive
//
//  Created by student on 5/24/21.
//

import UIKit

var imageName: String = ""

class NewSkillViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let s = Skill(number: skills.count, title: titleTextField.text!, image: imageName, note: "", video: "")
        skills.append(s)
    }
    
}
