import UIKit
import ImageSlideshow
import ImageSlideshowKingfisher
import Firebase
import FirebaseStorage

class AdminAllCarsViewDetailController: UIViewController {
    var car: Car!
    var allCars: [Car] = []
    let slideshow = ImageSlideshow()
    let brandLabel = UILabel()
    let modelLabel = UILabel()
    let bodyTypeLabel = UILabel()
    let colorLabel = UILabel()
    let engineCapacityLabel = UILabel()
    let transmissionLabel = UILabel()
    let pricePerDayLabel = UILabel()
    let freeCarLabel = UILabel()
    let editButton = UIButton(type: .system)
    let deleteButton = UIButton(type: .system)
    private let carManager = CarManager()
    private let databaseReference = Database.database().reference(fromURL: "https://coworkingapp-91bca-default-rtdb.asia-southeast1.firebasedatabase.app/")
    
    var tableView: UITableView!
    var editCarViewController: EditCarViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSlideshow()
        setupLabels()
        setupButtons()
        setupLayout()
        print("Loaded detail class carId: \(car.carId)")
        
        editCarViewController = EditCarViewController()
        editCarViewController?.delegate = self
    }
    
    func setupSlideshow() {
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        slideshow.contentScaleMode = .scaleAspectFill
        view.addSubview(slideshow)
        
        let imageInputs = car.photoURLs.compactMap { URL(string: $0) }.map { KingfisherSource(url: $0) }
        slideshow.setImageInputs(imageInputs)
    }
    
    func setupLabels() {
        let labels = [brandLabel, modelLabel, bodyTypeLabel, colorLabel, engineCapacityLabel, transmissionLabel, pricePerDayLabel, freeCarLabel]
        let details = ["Brand: \(car.brand)", "Model: \(car.model)", "Body Type: \(car.bodyType)", "Color: \(car.color)", "Engine Capacity: \(car.engineCapacity)", "Transmission: \(car.transmission)", "Price/Day: \(car.pricePerDay)", "Free Car: \(car.freeCar)"]
        
        for (index, label) in labels.enumerated() {
            label.translatesAutoresizingMaskIntoConstraints = false
            if index < details.count {
                label.text = details[index]
            }
            label.numberOfLines = 0
            view.addSubview(label)
        }
        
        updateLabels() // Update labels with car data
    }
    
    func updateLabels() {
        brandLabel.text = "Brand: \(car.brand)"
        modelLabel.text = "Model: \(car.model)"
        bodyTypeLabel.text = "Body Type: \(car.bodyType)"
        colorLabel.text = "Color: \(car.color)"
        engineCapacityLabel.text = "Engine Capacity: \(car.engineCapacity)"
        transmissionLabel.text = "Transmission: \(car.transmission)"
        pricePerDayLabel.text = "Price/Day: \(car.pricePerDay)"
        freeCarLabel.text = "Free Car: \(car.freeCar)"
    }
    
    func setupButtons() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        editButton.setTitle("Edit", for: .normal)
        editButton.backgroundColor = .blue
        editButton.setTitleColor(.white, for: .normal)
        editButton.layer.cornerRadius = 8
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.backgroundColor = .red
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.layer.cornerRadius = 8
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        view.addSubview(editButton)
        view.addSubview(deleteButton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            // Slideshow constraints
            slideshow.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            slideshow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slideshow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            slideshow.heightAnchor.constraint(equalToConstant: 250),
            
            // Labels constraints
            brandLabel.topAnchor.constraint(equalTo: slideshow.bottomAnchor, constant: 20),
            brandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            brandLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            modelLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 20),
            modelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            modelLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            bodyTypeLabel.topAnchor.constraint(equalTo: modelLabel.bottomAnchor, constant: 20),
            bodyTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bodyTypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            colorLabel.topAnchor.constraint(equalTo: bodyTypeLabel.bottomAnchor, constant: 20),
            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            engineCapacityLabel.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 20),
            engineCapacityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            engineCapacityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            transmissionLabel.topAnchor.constraint(equalTo: engineCapacityLabel.bottomAnchor, constant: 20),
            transmissionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            transmissionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            pricePerDayLabel.topAnchor.constraint(equalTo: transmissionLabel.bottomAnchor, constant: 20),
            pricePerDayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pricePerDayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            freeCarLabel.topAnchor.constraint(equalTo: pricePerDayLabel.bottomAnchor, constant: 20),
            freeCarLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            freeCarLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Buttons constraints
            editButton.topAnchor.constraint(equalTo: freeCarLabel.bottomAnchor, constant: 40),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            editButton.widthAnchor.constraint(equalToConstant: 100),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteButton.topAnchor.constraint(equalTo: freeCarLabel.bottomAnchor, constant: 40),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80),
            deleteButton.widthAnchor.constraint(equalToConstant: 100),
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func editButtonTapped() {
        guard let editCarViewController = editCarViewController else { return }
        editCarViewController.car = car // Передаем текущий автомобиль для редактирования
        editCarViewController.delegate = self
        navigationController?.pushViewController(editCarViewController, animated: true)
    }



    @objc func deleteButtonTapped() {
        deleteCar(carId: car.carId)
    }
    
    func deleteCar(carId: String) {
        databaseReference.child("cars").child(carId).removeValue { error, _ in
            if let error = error {
                print("Failed to delete car: \(error.localizedDescription)")
            } else {
                print("Car deleted successfully")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - EditCarDelegate

extension AdminAllCarsViewDetailController: EditCarDelegate {
    func carDidUpdate(updatedCar: Car) {
        self.car = updatedCar
        updateLabels()
    }
}
