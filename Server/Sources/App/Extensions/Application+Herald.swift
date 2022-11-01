//
//  Application+Herald.swift
//  
//
//  Created by Vladislav Grokhotov on 01.11.2022.
//

import Vapor

extension Application {
    
    static func getDatabaseUrl() throws -> URL {
        guard let dbUrl = Environment.get("DB_URL"), let url = URL(string: dbUrl) else {
            throw Abort(.internalServerError, reason: "No dbUrl provided")
        }
        
        return url
    }
}
