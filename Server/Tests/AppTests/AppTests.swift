@testable import App
import XCTVapor
import Fluent

final class AuthTests: XCTestCase {
    
    func testAuth() async throws {
        let app = Application(.testing)
        
        defer { app.shutdown() }
        
        try configure(app)

        let user = User(name: "name", username: "username", email: "email@email.com")
        
        try app.test(
            .POST, "signup",
            beforeRequest: { req in
                try req.content.encode(user)
            },
            afterResponse: { res in
                XCTAssertEqual(res.status, .created)
            }
        )
        
        let username = Username(username: user.username)
        
        try app.test(
            .POST, "email",
            beforeRequest: { req in
                try req.content.encode(username)
            },
            afterResponse: { res in
                XCTAssertEqual(res.status, .noContent)
            }
        )
        
        var headers = HTTPHeaders()
        
        headers.add(
            name: .authorization,
            value: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3JuIjoidXNlcm5hbWUiLCJleHAiOjY0MDkyMjExMjAwfQ.gJBnFeW-3b_ih6lP5gQGzhIbfvHsKUuTv6zfJ3ThkY0"
        )
        
        try await app.test(
            .POST, "signin",
            headers: headers,
            beforeRequest: { req in
                try req.content.encode(username)
                
                guard
                    let user = try await User.query(on: app.db).filter(\.$username == username.username).first()
                else {
                    throw Abort(.notFound, reason: "User does not exists")
                }
                
                user.secret = "1111"
                
                try await user.update(on: app.db)
            },
            afterResponse: { res in
                XCTAssertEqual(res.status, .accepted)
            }
        )
        
    }
    
    func testCleanAfterAuth() async throws {
        let app = Application(.testing)
        
        defer { app.shutdown() }
        
        try configure(app)
        
        try await app.test(
            .GET, "/",
            beforeRequest: { req in
                guard
                    let user = try await User.query(on: app.db).filter(\.$username == "username").first(),
                    let id = user.id
                else {
                    throw Abort(.notFound, reason: "User does not exists")
                }
                
                guard let userToken = try await UserToken.query(on: app.db).filter(\.$user.$id == id).first() else {
                    throw Abort(.notFound, reason: "UserToken does not exists")
                }
                
                try await userToken.delete(on: app.db)
                try await user.delete(on: app.db)
            },
            afterResponse: { res in
                XCTAssertEqual(res.status, .ok)
            }
        )
    }
}
