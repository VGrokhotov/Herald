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

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // db connection
    try app.databases.use(.postgres(url: Application.databaseUrl), as: .psql)
    
    // add migrations
    app.migrations.add(CreateUser())
    let _ = app.autoMigrate()
    
    // register routes
    try routes(app)
    
}
