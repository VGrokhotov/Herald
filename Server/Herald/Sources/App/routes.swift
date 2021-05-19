import Vapor
import VaporSMTPKit
import SMTPKitten

func routes(_ app: Application) throws {
    app.get { req in
        User.query(on: req.db).all()
    }

    app.post("signup") { req -> EventLoopFuture<User> in
        let user = try req.content.decode(User.self)
        return user.create(on: req.db)
            .map { user }
    }
    
    app.post("email") { req -> EventLoopFuture<HTTPStatus> in
        let email = Mail(
                from: "vladgrokhotov@gmail.com",
                to: [
                    MailUser(name: "Владислав Грохотов", email: "vlad@grokhotov.ru")
                ],
                subject: "Your new mail server!",
                contentType: .plain,
                text: "You've set up mail!"
            )
            
            return req.application.sendMail(email, withCredentials: .default).transform(to: .ok)
    }
}
