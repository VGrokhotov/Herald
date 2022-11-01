//
//  SMTPCredentials+Herald.swift
//  
//
//  Created by Vladislav Grokhotov on 01.11.2022.
//

import Vapor
import VaporSMTPKit

extension SMTPCredentials {
    
    static func getDefault() throws -> SMTPCredentials {
        guard let hostname = Environment.get("SMTP_HOSTNAME") else {
            throw Abort(.internalServerError, reason: "No hostname provided")
        }
        
        guard let email = Environment.get("EMAIL") else {
            throw Abort(.internalServerError, reason: "No email provided")
        }
        
        guard let password = Environment.get("EMAIL_PWD") else {
            throw Abort(.internalServerError, reason: "No email password provided")
        }
        
        return SMTPCredentials(
            hostname: hostname,
            ssl: .startTLS(configuration: .default),
            email: email,
            password: password
        )
    }
}
