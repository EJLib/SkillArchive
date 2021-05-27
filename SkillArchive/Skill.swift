//
//  ImageSkill.swift
//  SkillArchive
//
//  Created by student on 5/20/21.
//

import UIKit

class Skill: NSObject {
    var number: Int             //index of skills
    var title: String
    var image: String
    var note: String
//opt
    var video: String
    
    init(number: Int, title: String, image: String, note: String, video: String) {
        self.number = number
        self.title = title
        self.image = image
        self.note = note
        self.video = video
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
