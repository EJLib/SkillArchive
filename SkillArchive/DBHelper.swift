//
//  DBHelper.swift
//  SkillArchive
//
//  Created by user928829 on 11/21/21.
//

/*
 All code from https://www.raywenderlich.com/6620276-sqlite-with-swift-tutorial-getting-started
 */

import Foundation
import SQLite3

class DBHelper {
    
    init() {
        db = openDatabase()
        createTable()
        insert()
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
        let createTableString = "CREATE TABLE IF NOT EXISTS Skill(Id INTEGER PRIMARY KEY,Title TEXT,Image TEXT,Video TEXT,Note TEXT"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Contact table created")
            } else {
                print("Contact table is not created")
            }
        } else {
            print("CREATE TABLE statement is not prepared")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    let insertStatementString = "INSERT INTO Skill (Id, Title, Image, Video, Note) VALUES (?, ?, ?, ?, ?);"
    
    func insert() {
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let id: Int32 = 1  //temp
            let title: NSString = "test"  //temp
            sqlite3_bind_int(insertStatement, 1, id)
            sqlite3_bind_text(insertStatement, 2, title.utf8String, -1, nil)
            //add more
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row")
            } else {
                print("Could not insert row")
            }
        } else {
            print("INSERT statement is not prepared")
        }
        sqlite3_finalize(insertStatement)
    }
    
}



