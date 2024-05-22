import Foundation
import Alamofire
import Firebase

class LoginManager {
    static let shared = LoginManager()
    private init() {}

    func loginUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]

        let url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyB2PA5Wye07K0h4SiTh2hkAXpxEm5zQcTA"

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    // Если аутентификация успешна, передайте электронную почту в MyProfileViewController
                    if let userEmail = email as? String {
                        completion(nil) // Передаем nil, чтобы показать успешную аутентификацию
                        NotificationCenter.default.post(name: Notification.Name("UserLoggedIn"), object: nil, userInfo: ["email": userEmail])
                    }
                case .failure(let error):
                    print(error)
                    completion(error) // Передаем ошибку, чтобы показать неудачную аутентификацию
                }
            }
    }
}

