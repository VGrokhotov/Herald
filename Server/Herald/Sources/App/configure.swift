import Vapor
import Fluent
import FluentPostgresDriver
import VaporSMTPKit

extension Application {
    static let databaseUrl = URL(string: Environment.get("DB_URL")!)!
}

extension SMTPCredentials {
    static var `default`: SMTPCredentials {
        return SMTPCredentials(
            hostname: Environment.get("SMTP_HOSTNAME")!,
            ssl: .startTLS(configuration: .default),
            email:  Environment.get("EMAIL")!,
            password: Environment.get("EMAIL_PWD")!
        )
    }
}

extension EventLoopFuture {
    public func throwingFlatMap<NewValue>(_ transform: @escaping (Value) throws -> EventLoopFuture<NewValue>) -> EventLoopFuture<NewValue> {
        flatMap { value in
            do {
                return try transform(value)
            } catch {
                return self.eventLoop.makeFailedFuture(error)
            }
        }
    }
}

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // db connection
    try app.databases.use(.postgres(url: Application.databaseUrl), as: .psql)
    
    // add migrations
    app.migrations.add(User.Migration())
    app.migrations.add(UserToken.Migration())
    let _ = app.autoMigrate()
    
    // register routes
    try routes(app)
    
}
