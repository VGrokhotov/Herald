import Vapor
import Fluent
import FluentPostgresDriver
import VaporSMTPKit

extension Application {
    
    static func getDatabaseUrl() throws -> URL {
        guard let dbUrl = Environment.get("DB_URL"), let url = URL(string: dbUrl) else {
            throw Abort(.internalServerError, reason: "No dbUrl provided")
        }
        
        return url
    }
}

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

// configures your application
public func configure(_ app: Application) throws {
    // To serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // db connection
    let dbUrl = try Application.getDatabaseUrl()
    try app.databases.use(.postgres(url: dbUrl), as: .psql)
    
    // add migrations
    app.migrations.add(User.Migration())
    app.migrations.add(UserToken.Migration())
    app.migrations.add(Message.CreateMigration())
    app.migrations.add(Chat.CreateMigration())
    let _ = app.autoMigrate()
    
    // register routes
    try routes(app)
    
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080
}
