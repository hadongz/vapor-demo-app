import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped(["api", "v1", "todos"])
        let protectedTodos = todos.grouped(UserBearerAuthenticator())
        protectedTodos.get(use: getAll)
        protectedTodos.post(use: create)
        protectedTodos.group(":todoID") { todo in
            todo.get(use: getId)
            todo.delete(use: delete)
        }
    }
    
    func getAll(req: Request) async throws -> [Todo] {
        guard let userId = UUID(try req.auth.require(UserSession.self).token) else { throw Abort(.notFound) }
        return try await Todo.query(on: req.db).filter(\.$user.$id == userId).all()
    }
    
    func getId(req: Request) async throws -> Todo {
        guard
            let userId = UUID(try req.auth.require(UserSession.self).token),
            let todoId = UUID(req.parameters.get("todoID") ?? ""),
            let todo = try await Todo.find(todoId, on: req.db)
        else { throw Abort(.notFound) }
        
        if todo.$user.id != userId {
            throw Abort(.forbidden)
        } else {
            return todo
        }
    }

    func create(req: Request) async throws -> Todo {
        guard let userId = UUID(try req.auth.require(UserSession.self).token) else { throw Abort(.badRequest) }
        
        let dto = try req.content.decode(TodoDTO.self)
        let todo = Todo(userId: userId, title: dto.title, descriptions: dto.descriptions)
        try await todo.create(on: req.db)
        return todo
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard
            let userId = UUID(try req.auth.require(UserSession.self).token),
            let todoId = UUID(req.parameters.get("todoID") ?? ""),
            let todo = try await Todo.find(todoId, on: req.db)
        else { throw Abort(.notFound) }
        
        if todo.$user.id != userId {
            return .forbidden
        } else {
            try await todo.delete(on: req.db)
            return .ok
        }
    }
}
