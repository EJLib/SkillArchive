//
//  SkillsViewController.swift
//  SkillArchive
//
//  Created by student on 5/20/21.
//

import UIKit

class SkillsViewController: UICollectionViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        i = 0
        
       navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(segueToNewSkill))
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        editSkill = indexPath[1]
        performSegue(withIdentifier: "SkillsToNewSkill", sender: nil)
        //indexPath seems to be [0, 0], [0, 1], etc. but not sure
    }
    
    @objc func segueToNewSkill() {
        performSegue(withIdentifier: "SkillsToNewSkill", sender: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skills.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCellView", for: indexPath) as? SkillCell else {
            fatalError("Unable to dequeue Skill.")
        }
        
        let path = getDocumentsDirectory().appendingPathComponent(skills[i].image)
        cell.skillImage.image = UIImage(contentsOfFile: path.path)
        cell.skillTitle.text = skills[i].title
        i += 1
        
        return cell
    }
    
    
    /*
    //might move to a create new skill entry screen
    @IBAction func importNew() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let s = Skill(number: skills.count, title: "", image: imageName, note: "", video: "")
        skills.append(s)
            //set title at some point - opt?
        
        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    */

}
