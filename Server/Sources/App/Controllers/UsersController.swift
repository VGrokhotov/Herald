//
//  UsersController.swift
//  
//
//  Created by Vladislav Grokhotov on 06.11.2022.
//

import Vapor
import Fluent

final class UsersController {
    
    func find(_ req: Request) async throws -> Response {
        let username = try req.query.decode(Username.self)
        
        return try await User.query(on: req.db)
            .filter(\.$username =~ username.username)
            .paginate(PageRequest(page: 1, per: 5))
            .map { SearchUser(username: $0.username, name: $0.name) }
            .encodeResponse(status: .ok, for: req)
    }
}
