import SwiftyJSON

public struct Todo {
    public let id: String?
    public let title: String
    public let order: Double?
    public let completed: Bool?

    public init(id: String?, title: String, order: Double?, completed: Bool?) {
        self.id = id
        self.title = title
        self.order = order
        self.completed = completed
    }

    public init(json: JSON) throws {
        // Required properties
        guard json["title"].exists() else {
            throw ModelError.requiredPropertyMissing(name: "title")
        }
        guard let title = json["title"].string else {
            throw ModelError.propertyTypeMismatch(name: "title", type: "string", value: json["title"].description, valueType: String(describing: json["title"].type))
        }
        self.title = title

        // Optional properties
        if json["id"].exists() &&
           json["id"].type != .string {
            throw ModelError.propertyTypeMismatch(name: "id", type: "string", value: json["id"].description, valueType: String(describing: json["id"].type))
        }
        self.id = json["id"].string
        if json["order"].exists() &&
           json["order"].type != .number {
            throw ModelError.propertyTypeMismatch(name: "order", type: "number", value: json["order"].description, valueType: String(describing: json["order"].type))
        }
        self.order = json["order"].number.map { Double($0) }
        if json["completed"].exists() &&
           json["completed"].type != .bool {
            throw ModelError.propertyTypeMismatch(name: "completed", type: "boolean", value: json["completed"].description, valueType: String(describing: json["completed"].type))
        }
        self.completed = json["completed"].bool ?? false

        // Check for extraneous properties
        if let jsonProperties = json.dictionary?.keys {
            let properties: [String] = ["id", "title", "order", "completed"]
            for jsonPropertyName in jsonProperties {
                if !properties.contains(where: { $0 == jsonPropertyName }) {
                    throw ModelError.extraneousProperty(name: jsonPropertyName)
                }
            }
        }
    }

    public func settingID(_ newId: String?) -> Todo {
      return Todo(id: newId, title: title, order: order, completed: completed)
    }

    public func updatingWith(json: JSON) throws -> Todo {
        if json["id"].exists() &&
           json["id"].type != .string {
            throw ModelError.propertyTypeMismatch(name: "id", type: "string", value: json["id"].description, valueType: String(describing: json["id"].type))
        }
        let id = json["id"].string ?? self.id

        if json["title"].exists() &&
           json["title"].type != .string {
            throw ModelError.propertyTypeMismatch(name: "title", type: "string", value: json["title"].description, valueType: String(describing: json["title"].type))
        }
        let title = json["title"].string ?? self.title

        if json["order"].exists() &&
           json["order"].type != .number {
            throw ModelError.propertyTypeMismatch(name: "order", type: "number", value: json["order"].description, valueType: String(describing: json["order"].type))
        }
        let order = json["order"].number.map { Double($0) } ?? self.order

        if json["completed"].exists() &&
           json["completed"].type != .bool {
            throw ModelError.propertyTypeMismatch(name: "completed", type: "boolean", value: json["completed"].description, valueType: String(describing: json["completed"].type))
        }
        let completed = json["completed"].bool ?? self.completed

        return Todo(id: id, title: title, order: order, completed: completed)
    }

    public func toJSON() -> JSON {
        var result = JSON([
            "title": JSON(title),
        ])
        if let id = id {
            result["id"] = JSON(id)
        }
        if let order = order {
            result["order"] = JSON(order)
        }
        if let completed = completed {
            result["completed"] = JSON(completed)
        }

        return result
    }
}
