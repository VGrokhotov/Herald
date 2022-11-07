@testable import App
import XCTVapor
import Fluent

final class AuthTests: XCTestCase {
    
    private enum Constants {
        
        static let username = "username"
        static let name = "name"
        static let email = "email@email.com"
        static let secret = "1111"
        
        static let authBearer = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3JuIjoidXNlcm5hbWUiLCJleHAiOjY0MDkyMjExMjAwfQ.gJBnFeW-3b_ih6lP5gQGzhIbfvHsKUuTv6zfJ3ThkY0"
    }
    
    static var app = Application(.testing)
    
    override class func setUp() {
        try? configure(Self.app)
    }
    
    override class func tearDown() {
        Self.app.shutdown()
    }
    
    override func setUp() async throws {
        let user = User(name: Constants.name, username: Constants.username, email: Constants.email)
        
        if try await User.query(on: Self.app.db).filter(\.$username == Constants.username).first() == nil {
            try await user.create(on: Self.app.db)
        }
    }
    
    override func tearDown() async throws {
        try await clean()
    }
    
    func testAuth() async throws {
        let username = Username(username: Constants.username)
        
        try Self.app.test(
            .POST, "email",
            beforeRequest: { req in
                try req.content.encode(username)
            },
            afterResponse: { res in
                XCTAssertEqual(res.status, .noContent)
            }
        )
        
        var headers = HTTPHeaders()
        headers.add(name: .authorization, value: Constants.authBearer)
        
        try await Self.app.test(
            .POST, "signin",
            headers: headers,
            beforeRequest: { req in
                try req.content.encode(username)
                
                guard
                    let user = try await User.query(on: Self.app.db).filter(\.$username == username.username).first()
                else {
                    throw Abort(.notFound, reason: "User does not exists")
                }
                
                user.secret = Constants.secret
                
                try await user.update(on: Self.app.db)
            },
            afterResponse: { res in
                XCTAssertEqual(res.status, .accepted)
            }
        )
        
    }
    
    func testFindUser() async throws {
        try await testAuth()
        
        var headers = HTTPHeaders()
        headers.add(name: .authorization, value: Constants.authBearer)
        
        try Self.app.test(
            .GET,
            "users/find",
            headers: headers,
            beforeRequest: { req in
                try req.query.encode(Username(username: Constants.username))
            },
            afterResponse: { res in
                XCTAssertEqual(res.status, .ok)
                
                guard let page = try? res.content.decode(Page<SearchUser>.self) else {
                    return XCTAssert(false, "Invalid responce")
                }
                
                XCTAssertEqual(page.items.first?.name, Constants.name)
            }
        )
    }
    
    private func clean() async throws {
        guard let user = try await User.query(on: Self.app.db).filter(\.$username == Constants.username).first() else {
            throw Abort(.notFound, reason: "User does not exists")
        }
        
        guard
            let id = user.id,
            let userToken = try await UserToken.query(on: Self.app.db).filter(\.$user.$id == id).first()
        else {
            throw Abort(.notFound, reason: "UserToken does not exists")
        }
        
        try await userToken.delete(on: Self.app.db)
        try await user.delete(on: Self.app.db)
    }
}
