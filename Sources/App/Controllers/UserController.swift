import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")
        let v1 = api.grouped("v1")
        v1.post("login", use: login)
        v1.get("get-token", use: getToken)
    }
    
    func login(req: Request) async throws -> User {
        let dto = try req.content.decode(UserLoginDTO.self)

        if let user = try await User.query(on: req.db).filter(\.$username == dto.username).first() {
            req.session.data["id"] = user.id?.uuidString ?? ""
            return user
        } else {
            let newUser = User(username: dto.username)
            try await newUser.save(on: req.db)
            let user = try await User.query(on: req.db).filter(\.$username == dto.username).first()
            req.session.data["id"] = user?.id?.uuidString ?? ""
            return user!
        }
    }
    
    func getToken(req: Request) async throws -> String {
        return req.session.data["id"] ?? ""
    }
}
