import Fluent
import Vapor

struct TodoDTO: Content {
    let title: String
    let descriptions: String
}

final class Todo: Model, Content {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User

    @Field(key: "title")
    var title: String
    
    @Field(key: "descriptions")
    var descriptions: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() { }

    init(
        id: UUID? = nil,
        userId: User.IDValue,
        title: String,
        descriptions: String
    ) {
        self.id = id
        self.title = title
        self.descriptions = descriptions
        self.$user.id = userId
    }
}
