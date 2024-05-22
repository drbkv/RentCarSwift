//
//  OrderPopupViewController.swift
//  Coworking
//
//  Created by Ramzan on 20.05.2024.
//

import Foundation
import UIKit
import Firebase

class OrderPopupViewController: UIViewController {
    
    var orderId: String
    var status: OrderStatus = .inProgress
    
    private lazy var nameLabel: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var phoneNumberLabel: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Номер телефона"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отправить заказ", for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitOrder), for: .touchUpInside)
        return button
    }()
    
    
    
    init(orderId: String) {
        self.orderId = orderId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(phoneNumberLabel)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50), // Move up by 50 points
            
            phoneNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            phoneNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            submitButton.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    
    
    @objc private func submitOrder() {
        guard let name = nameLabel.text, let phoneNumber = phoneNumberLabel.text else {
            // Handle empty fields
            return
        }
        
        // Save the order to Firebase with auto-generated orderId
        let orderRef = Database.database().reference().child("orders").childByAutoId()
        let orderId = orderRef.key ?? "" // Получаем orderId из childByAutoId()
        let orderData: [String: Any] = [
            "orderId": orderId, // Используем правильное имя поля
            "name": name,
            "phoneNumber": phoneNumber,
            "status": OrderStatus.inProgress.rawValue
        ]
        
        orderRef.setValue(orderData) { error, _ in
            if let error = error {
                print("Error saving order: \(error.localizedDescription)")
            } else {
                print("Order saved successfully")
                // Dismiss the popup
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
