//
//  SQLiteDatabase.swift
//  SkillArchive
//
//  Created by user930654 on 7/30/22.
//

/*
 All code from https://www.raywenderlich.com/6620276-sqlite-with-swift-tutorial-getting-started
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
}

extension Skill: SQLTable {
    static var createStatement: String {
        return """
            CREATE TABLE Skill(Id INTEGER PRIMARY KEY,Title TEXT,Image TEXT,Video TEXT,Note TEXT);
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

// insertions
extension SQLiteDatabase {
    func insertSkill(skill: Skill) throws {
        let insertSQL = "INSERT INTO Skill (Id, Title, Image, Video, Note) VALUES (?, ?, ?, ?, ?);"
        let insertStatement = try prepareStatement(sql: insertSQL)
        defer {
            sqlite3_finalize(insertStatement)
        }
        guard
            sqlite3_bind_int(insertStatement, 1, Int32(skill.id)) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 2, skill.title, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 3, skill.image, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 4, skill.video, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 5, skill.note, -1, nil) == SQLITE_OK
            else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Successfully inserted row.")
    }
}
