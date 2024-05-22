    import Foundation
    import Firebase
    class RegistrationManager {
        static let shared = RegistrationManager()
        private init() {}
        
        func registerUser(email: String, password: String, name: String, surname: String, dateOfBirth: String, completion: @escaping (Error?) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    completion(error)
                } else {
                    guard let userId = authResult?.user.uid else {
                        completion(NSError(domain: "RegistrationManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"]))
                        return
                    }
                    
                    let userData = UserData(userId: userId, email: email, name: name, surname: surname, dateOfBirth: dateOfBirth, role: "user") // Устанавливаем роль "user"
                    
                    let databaseReference = Database.database().reference()
                    databaseReference.child("users").child(userId).setValue(userData.toDictionary()) { error, _ in
                        if let error = error {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
