import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        "Hello"
    }
    
    let authController = AuthController()
    
    app.post("signup", use: authController.create)
        .description("Creates new User")
    app.post("email", use: authController.email)
        .description("Sends email with code")
    app.post("signin", use: authController.signin)
        .description("Returns token")
}
