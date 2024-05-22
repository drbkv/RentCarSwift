

struct UserData {
    let userId: String
    let email: String
    let name: String
    let surname: String
    let dateOfBirth: String
    let role: String

    func toDictionary() -> [String: Any] {
        return [
            "email": email,
            "name": name,
            "surname": surname,
            "dateOfBirth": dateOfBirth,
            "role": role
        ]
    }
}
