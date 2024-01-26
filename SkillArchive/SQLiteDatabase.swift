//
//  SQLiteDatabase.swift
//  SkillArchive
//
//  Created by user930654 on 7/30/22.
//

/*
 Most code from https://www.raywenderlich.com/6620276-sqlite-with-swift-tutorial-getting-started
 */

import Foundation
import SQLite3

enum SQLiteError : Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}

class SQLiteDatabase {
    private let dbPointer: OpaquePointer?
    private init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    deinit {
        sqlite3_close(dbPointer)
    }
    
    static func open(path: String) throws -> SQLiteDatabase {
        var db: OpaquePointer?
        if sqlite3_open(path, &db) == SQLITE_OK {
            return SQLiteDatabase(dbPointer: db)
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String(cString: errorPointer)
                throw SQLiteError.OpenDatabase(message: message)
            } else {
                throw SQLiteError.OpenDatabase(message: "No error message provided from SQLite.")
            }
        }
    }
    
    var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }
}

extension SQLiteDatabase {
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.Prepare(message: errorMessage)
        }
        return statement
    }
}

// table creation
protocol SQLTable {
    static var createStatement: String { get }
    static var dropStatement: String { get }
}

extension Skill: SQLTable {
    static var createStatement: String {
        return """
            CREATE TABLE IF NOT EXISTS Skills(Id INTEGER PRIMARY KEY,Title TEXT,Image TEXT,Video TEXT,Note TEXT);
            """
    }
    // not from tutorial
    static var dropStatement: String {
        return """
            DROP TABLE IF EXISTS Skills;
            """
    }
}

extension SQLiteDatabase {
    func createTable(table: SQLTable.Type) throws {
        let createTableStatement = try prepareStatement(sql: table.createStatement)
        defer {
            sqlite3_finalize(createTableStatement)
        }
        guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("\(table) table created")
    }
}

// not from tutorial
extension SQLiteDatabase {
    func dropTable(table: SQLTable.Type) throws {
        let dropTableStatement = try prepareStatement(sql: table.dropStatement)
        defer {
            sqlite3_finalize(dropTableStatement)
        }
        guard sqlite3_step(dropTableStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("\(table) table dropped")
    }
}

// insertions
extension SQLiteDatabase {
    func insertSkill(skill: Skill) throws {
        let insertSQL = "INSERT INTO Skills (Title, Image, Video, Note) VALUES (?, ?, ?, ?);"
        let insertStatement = try prepareStatement(sql: insertSQL)
        defer {
            sqlite3_finalize(insertStatement)
        }
        let title = skill.title as NSString
        let image = skill.image as NSString
        let video = skill.video as NSString
        let note = skill.note as NSString
        guard
                sqlite3_bind_text(insertStatement, 1, title.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(insertStatement, 2, image.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(insertStatement, 3, video.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(insertStatement, 4, note.utf8String, -1, nil) == SQLITE_OK
        else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Successfully inserted row.")
    }
}

// not from tutorial
// updates
extension SQLiteDatabase {
    func updateSkill(id: Int, skill: Skill) throws {
        let updateSQL = "UPDATE Skills Set Title=?, Image=?, Video=?, Note=? WHERE Id=?;"
        let updateStatement = try prepareStatement(sql: updateSQL)
        defer {
            sqlite3_finalize(updateStatement)
        }
        let title = skill.title as NSString
        let image = skill.image as NSString
        let video = skill.video as NSString
        let note = skill.note as NSString
        guard
                sqlite3_bind_text(updateStatement, 1, title.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(updateStatement, 2, image.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(updateStatement, 3, video.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(updateStatement, 4, note.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_int(updateStatement, 5, Int32(id)) == SQLITE_OK
        else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(updateStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Successfully updated row.")
    }
}

extension SQLiteDatabase {
    func getOneSkill(id: Int) -> Skill? {
        let querySQL = "SELECT * FROM Skills WHERE Id = ?;"
        guard let queryStatement = try? prepareStatement(sql: querySQL) else {
            return nil
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        guard sqlite3_bind_int(queryStatement, 1, Int32(id)) == SQLITE_OK else {
            return nil
        }
        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
            return nil
        }
        guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
            return nil
        }
        let title = String(cString: queryResultCol1)
        let image = String(cString: sqlite3_column_text(queryStatement, 2))
        let note = String(cString: sqlite3_column_text(queryStatement, 3))
        let video = String(cString: sqlite3_column_text(queryStatement, 4))
        return Skill( title: title, image: image, note: note, video: video)
        
    }
}



// not from tutorial
extension SQLiteDatabase {
    func getAllSkills() -> [Skill]? {
        let querySQL = "SELECT * FROM Skills;"
        guard let queryStatement = try? prepareStatement(sql: querySQL) else {
            return nil
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        var result: [Skill] = []
        while true {
            guard sqlite3_step(queryStatement) == SQLITE_ROW else {
                break
            }
            guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
            else {
                break
            }
            let title = String(cString: queryResultCol1)
            let image = String(cString: sqlite3_column_text(queryStatement, 2))
            let note = String(cString: sqlite3_column_text(queryStatement, 3))
            let video = String(cString: sqlite3_column_text(queryStatement, 4))
            result.append(Skill(title: title, image: image, note: note, video: video));
        }
        return result;
    }
}

// not from tutorial
extension SQLiteDatabase {
    func deleteSkill(id: Int) throws {
        let deleteSQL = "DELETE FROM Skills WHERE Id = ?;"
        let deleteStatement = try prepareStatement(sql: deleteSQL)
        defer {
            sqlite3_finalize(deleteStatement)
        }
        guard sqlite3_bind_int(deleteStatement, 1, Int32(id)) == SQLITE_OK else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(deleteStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Successfully deleted row.")
    }
}
