//
//  AdminOrdersViewController.swift
//  Coworking
//
//  Created by Ramzan on 20.05.2024.
//
import Foundation
import UIKit
import Firebase

class AdminOrdersViewController: UIViewController {
    
    private var orders: [Order] = []
    private var ordersRef: DatabaseReference!
    private var ordersHandle: DatabaseHandle!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self // Добавляем делегата для обработки нажатий на ячейки
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Заявки"
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        ordersRef = Database.database().reference().child("orders")
        observeOrders()
    }
    
    deinit {
        ordersRef.removeObserver(withHandle: ordersHandle)
    }
    
    private func observeOrders() {
        ordersHandle = ordersRef.observe(DataEventType.value, with: { snapshot in
            self.orders.removeAll()
            
            for case let childSnapshot as DataSnapshot in snapshot.children {
                if let orderData = childSnapshot.value as? [String: Any],
                   let orderId = orderData["orderId"] as? String,
                   let name = orderData["name"] as? String,
                   let phoneNumber = orderData["phoneNumber"] as? String,
                   let statusString = orderData["status"] as? String,
                   let status = OrderStatus(rawValue: statusString) {
                    
                    let order = Order(orderId: orderId, name: name, phoneNumber: phoneNumber, status: status)
                    self.orders.append(order)
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    private func updateOrderStatus(orderId: String, newStatus: OrderStatus) {
        let orderRef = ordersRef.child(orderId)
        orderRef.updateChildValues(["status": newStatus.rawValue]) { error, _ in
            if let error = error {
                print("Error updating order status: \(error.localizedDescription)")
            } else {
                print("Order status updated successfully")
            }
        }
    }
}

extension AdminOrdersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let order = orders[indexPath.row]
        cell.textLabel?.text = "\(order.name), \(order.phoneNumber), \(order.status.rawValue)"
        return cell
    }
}

extension AdminOrdersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = orders[indexPath.row]
        let alertController = UIAlertController(title: "Изменить статус", message: "Выберите новый статус для заказа", preferredStyle: .alert)
        
        let statusCases: [OrderStatus] = [.inProgress, .completed]
        for status in statusCases {
            let action = UIAlertAction(title: status.rawValue, style: .default) { _ in
                self.updateOrderStatus(orderId: order.orderId, newStatus: status)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
