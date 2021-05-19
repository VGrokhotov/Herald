@testable import App
import XCTVapor
import Fluent

final class AuthTests: XCTestCase {
    
    func testAuth() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let user = User(name: "name", username: "username", email: "email@email.com")
        
        try app.test(.POST, "signup", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .created)
        })
        
        let username = Username(username: user.username)
        
        try app.test(.POST, "email", beforeRequest: { req in
            try req.content.encode(username)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
        
        var headers = HTTPHeaders()
        headers.add(name: .authorization, value: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3JuIjoidXNlcm5hbWUiLCJleHAiOjY0MDkyMjExMjAwfQ.gJBnFeW-3b_ih6lP5gQGzhIbfvHsKUuTv6zfJ3ThkY0")
        
        try app.test(.POST, "signin", headers: headers, beforeRequest: { req in
            try req.content.encode(username)
            try User.query(on: app.db)
                .filter(\.$username == username.username)
                .first()
                .unwrap(or: Abort(.notFound, reason: "User does not exists"))
                .flatMap({ user -> EventLoopFuture<Void> in
                    user.secret = "1111"
                    return user.update(on: app.db)
                }).wait()
    
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .accepted)
        })
        
    }
    
    func cleanAfterAuth() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.test(.GET, "/", beforeRequest: { req in
            try User.query(on: app.db)
                .filter(\.$username == "username")
                .first()
                .unwrap(or: Abort(.notFound, reason: "User does not exists"))
                .throwingFlatMap({ user -> EventLoopFuture<User> in
                    let id = user.id!
                    return UserToken.query(on: app.db)
                        .filter(\.$user.$id == id)
                        .first()
                        .unwrap(or: Abort(.notFound, reason: "UserToken does not exists"))
                        .throwingFlatMap({ token -> EventLoopFuture<User> in
                            return token.delete(on: app.db).map({ _  -> User in
                                return user
                            })
                        })
                })
                .throwingFlatMap({ user -> EventLoopFuture<Void> in
                    return user.delete(on: app.db)
                })
                .wait()
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }

}
