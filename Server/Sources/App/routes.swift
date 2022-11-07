import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        "Hello"
    }

    let authController = AuthController()
    let usersController = UsersController()
    let tokenProtected = app.grouped(UserToken.authenticator())
    
    app.post("signup", use: authController.create).description("Creates new User")
    app.post("email", use: authController.email).description("Sends email with code")
    app.post("signin", use: authController.signIn).description("Returns token")
    
    tokenProtected.post("logout", use: authController.logOut).description("Deletes token")
    tokenProtected.get("users", "find", use: usersController.find).description("Find user by username")
}
