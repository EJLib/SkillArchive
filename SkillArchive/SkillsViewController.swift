//
//  SkillsViewController.swift
//  SkillArchive
//
//  Created by student on 5/20/21.
//

import UIKit

class SkillsViewController: UICollectionViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // used in collectionView to iterate through skill images and titles
    var currentSkillIndex = 0
    // set from database when this page is loaded
    var skills: [Skill] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load up skills with those stored in database
        skills = (db?.getAllSkills())!
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(segueToNewSkill))
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        skillID = indexPath[1]+1    // +1 because the database starts with Ids at 1 not 0
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
        
        // sets image and title
        let path = getDocumentsDirectory().appendingPathComponent(skills[currentSkillIndex].image)
        cell.skillImage.image = UIImage(contentsOfFile: path.path)
        cell.skillTitle.text = skills[currentSkillIndex].title
        currentSkillIndex += 1
        
        return cell
    }
}
