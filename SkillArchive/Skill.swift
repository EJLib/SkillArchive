//
//  ImageSkill.swift
//  SkillArchive
//
//  Created by student on 5/20/21.
//

import UIKit

class Skill: NSObject {
    var title: String
    var image: String
    var note: String
    var video: String
    
    init(title: String, image: String, note: String, video: String) {
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
