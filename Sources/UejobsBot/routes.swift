import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("ue") { req async -> String in
        "jobs!"
    }

    let lineController = LineWebhookController()
    app.post("webhook", use: lineController.receive(_:))
    app.post("callback", use: lineController.receive(_:))
    
    try app.register(collection: TodoController())
}
