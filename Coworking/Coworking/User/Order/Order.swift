import Foundation
enum OrderStatus: String {
    case inProgress = "inProgress"
    case completed = "completed"
}
struct Order {
    let orderId: String
    let name: String
    let phoneNumber: String
    var status: OrderStatus
}
