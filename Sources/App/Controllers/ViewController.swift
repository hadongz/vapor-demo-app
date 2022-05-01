import Fluent
import Vapor

struct ViewController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: login)
        routes.get("todos", use: todos)
    }
    
    func login(req: Request) async throws -> View {
        return try await req.view.render("login")
    }
    
    func todos(req: Request) async throws -> View {
        guard
            let id = UUID(req.session.data["id"] ?? ""),
            let user = try await User
                .query(on: req.db)
                .filter(\.$id == id)
                .with(\.$todos)
                .first(),
            let userId = user.id?.uuidString
        else { throw Abort(.notFound) }
        
        let viewModel = UserViewModel(
            id: userId,
            username: user.username,
            todos: user.todos
        )
        
        return try await req.view.render("todos", viewModel)
    }
}
