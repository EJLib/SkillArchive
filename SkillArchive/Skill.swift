//
//  ImageSkill.swift
//  SkillArchive
//
//  Created by student on 5/20/21.
//

import UIKit

class Skill: NSObject {
    var id: Int             //index of skills
    var title: String
    var image: String
    var note: String
//opt
    var video: String
    
    init(id: Int, title: String, image: String, note: String, video: String) {
        self.id = id
        self.title = title
        self.image = image
        self.note = note
        self.video = video
    }
}

/* function from https://www.hackingwithswift.com/read/10/4/importing-photos-with-uiimagepickercontroller
*/
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
