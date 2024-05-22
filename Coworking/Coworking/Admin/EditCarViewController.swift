import UIKit
import FirebaseDatabase

protocol EditCarDelegate: AnyObject {
    func carDidUpdate(updatedCar: Car)
}

class EditCarViewController: UIViewController {
    var car: Car!
    weak var delegate: EditCarDelegate?
    
    private let brandTextField = UITextField()
    private let modelTextField = UITextField()
    private let bodyTypeTextField = UITextField()
    private let colorTextField = UITextField()
    private let engineCapacityTextField = UITextField()
    private let transmissionTextField = UITextField()
    private let pricePerDayTextField = UITextField()
    private let freeCarSwitch = UISwitch()
    private let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTextFields()
        setupSaveButton()
        setupLayout()
        
        populateFields()
    }
    
    func setupTextFields() {
        let textFields = [brandTextField, modelTextField, bodyTypeTextField, colorTextField, engineCapacityTextField, transmissionTextField, pricePerDayTextField]
        let placeholders = ["Brand", "Model", "Body Type", "Color", "Engine Capacity", "Transmission", "Price/Day"]
        
        for (index, textField) in textFields.enumerated() {
            textField.placeholder = placeholders[index]
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(textField)
        }
        
        freeCarSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(freeCarSwitch)
    }
    
    func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .blue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            brandTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            brandTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            brandTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            modelTextField.topAnchor.constraint(equalTo: brandTextField.bottomAnchor, constant: 20),
            modelTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            modelTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            bodyTypeTextField.topAnchor.constraint(equalTo: modelTextField.bottomAnchor, constant: 20),
            bodyTypeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bodyTypeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            colorTextField.topAnchor.constraint(equalTo: bodyTypeTextField.bottomAnchor, constant: 20),
            colorTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            engineCapacityTextField.topAnchor.constraint(equalTo: colorTextField.bottomAnchor, constant: 20),
            engineCapacityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            engineCapacityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            transmissionTextField.topAnchor.constraint(equalTo: engineCapacityTextField.bottomAnchor, constant: 20),
            transmissionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            transmissionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            pricePerDayTextField.topAnchor.constraint(equalTo: transmissionTextField.bottomAnchor, constant: 20),
            pricePerDayTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pricePerDayTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            freeCarSwitch.topAnchor.constraint(equalTo: pricePerDayTextField.bottomAnchor, constant: 20),
            freeCarSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            saveButton.topAnchor.constraint(equalTo: freeCarSwitch.bottomAnchor, constant: 40),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func populateFields() {
        brandTextField.text = car.brand
        modelTextField.text = car.model
        bodyTypeTextField.text = car.bodyType
        colorTextField.text = car.color
        engineCapacityTextField.text = car.engineCapacity
        transmissionTextField.text = car.transmission
        pricePerDayTextField.text = "\(car.pricePerDay)"
        freeCarSwitch.isOn = car.freeCar
    }
    func saveUpdatedCar(updatedCar: Car) {
        let databaseReference = Database.database().reference(fromURL: "https://coworkingapp-91bca-default-rtdb.asia-southeast1.firebasedatabase.app/")
        databaseReference.child("cars").child(updatedCar.carId).updateChildValues(updatedCar.toDictionary()) { error, _ in
            if let error = error {
                print("Failed to update car: \(error.localizedDescription)")
            } else {
                self.delegate?.carDidUpdate(updatedCar: updatedCar)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    
    @objc func saveButtonTapped() {
        guard let brand = brandTextField.text,
              let model = modelTextField.text,
              let bodyType = bodyTypeTextField.text,
              let color = colorTextField.text,
              let engineCapacity = engineCapacityTextField.text,
              let transmission = transmissionTextField.text,
              let pricePerDayString = pricePerDayTextField.text,
              let pricePerDay = Double(pricePerDayString) else {
            print("Please fill out all fields correctly.")
            return
        }
        
        // Обновляем свойства текущего автомобиля
        car.brand = brand
        car.model = model
        car.bodyType = bodyType
        car.color = color
        car.engineCapacity = engineCapacity
        car.transmission = transmission
        car.pricePerDay = pricePerDay
        car.freeCar = freeCarSwitch.isOn
        
        // Вызываем метод обновления автомобиля
        saveUpdatedCar(updatedCar: car)
    }
}

// Extension to convert Car to dictionary
extension Car {
    func toDictionary() -> [String: Any] {
        return [
            "carId": carId,
            "photoURLs": photoURLs,
            "brand": brand,
            "model": model,
            "bodyType": bodyType,
            "color": color,
            "engineCapacity": engineCapacity,
            "transmission": transmission,
            "pricePerDay": pricePerDay,
            "freeCar": freeCar
        ]
    }
}
