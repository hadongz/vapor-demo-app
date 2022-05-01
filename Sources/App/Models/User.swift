import Fluent
import Vapor

struct UserLoginDTO: Content {
    var username: String
}

struct UserViewModel: Content {
    var id: String
    var username: String
    var todos: [Todo]
}

struct UserSession: Authenticatable {
    var token: String
}

struct UserBearerAuthenticator: AsyncBearerAuthenticator {
    
    func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
        request.auth.login(UserSession(token: bearer.token))
    }
}

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Children(for: \Todo.$user)
    var todos: [Todo]
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(
        id: UUID? = nil,
        username: String
    ) {
        self.id = id
        self.username = username
    }
}
