import Vapor
import Fluent
import FluentPostgresDriver

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
