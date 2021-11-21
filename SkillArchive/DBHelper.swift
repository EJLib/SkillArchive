//
//  DBHelper.swift
//  SkillArchive
//
//  Created by user928829 on 11/21/21.
//

import Foundation
import SQLite3

class DBHelper {
    
    init() {
        db = openDatabase()
        createTable()
    }
    
    let dbPath: String = "archiveDb.sqlite"
    var db:OpaquePointer?
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return nil
        } else {
            print("Successfully opened conection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        // optional values could be a problem
        let createTableString = "CREATE TABLE IF NOT EXISTS skill(Id INTEGER PRIMARY KEY,name TEXT,image TEXT,video TEXT,note TEXT"
        var createTableStatement: OpaquePointer? = nil
        // more
    }
    
}



