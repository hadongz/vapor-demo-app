import Fluent

struct CreateTodo: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Todo.schema)
            .id()
            .field("user_id", .uuid, .required, .references(User.schema, .id))
            .field("title", .string, .required)
            .field("descriptions", .string, .required)
            .field("created_at", .date)
            .field("updated_at", .date)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Todo.schema).delete()
    }
}
