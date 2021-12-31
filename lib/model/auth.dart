// To parse this JSON data, do
//
//     final auth = authFromJson(jsonString);


class Auth {
    Auth({
        this.id,
        this.name,
        this.username,
        this.pin,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String name;
    String username;
    String pin;
    DateTime createdAt;
    DateTime updatedAt;

    factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        username: json["username"] == null ? null : json["username"],
        pin: json["pin"] == null ? null : json["pin"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "username": username == null ? null : username,
        "pin": pin == null ? null : pin,
        
    };
}
