

import Foundation
import UIKit
import Firebase
import SDWebImage

class AdminAllCarsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var car: Car?

    private let databaseReference = Database.database().reference(fromURL: "https://coworkingapp-91bca-default-rtdb.asia-southeast1.firebasedatabase.app/")
    private var allCars: [Car] = []
    private var allCarsHandle: DatabaseHandle?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        observeAllCars()
    }

    func observeAllCars() {
        let allCarsRef = databaseReference.child("cars")
        allCarsHandle = allCarsRef.observe(.value) { snapshot in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                print("No cars found")
                return
            }

            self.allCars.removeAll()

            for snap in snapshots {
                guard let dict = snap.value as? [String: Any] else {
                    continue
                }

                let carId = dict["carId"] as? String ?? ""
                let photoURLs = dict["photoURLs"] as? [String] ?? []
                let brand = dict["brand"] as? String ?? ""
                let model = dict["model"] as? String ?? ""
                let bodyType = dict["bodyType"] as? String ?? ""
                let color = dict["color"] as? String ?? ""
                let engineCapacity = dict["engineCapacity"] as? String ?? ""
                let transmission = dict["transmission"] as? String ?? ""
                let pricePerDay = dict["pricePerDay"] as? Double ?? 0.0
                let freeCar = dict["freeCar"] as? Bool ?? true

                let car = Car(carId: carId, photoURLs: photoURLs, brand: brand, model: model, bodyType: bodyType, color: color, engineCapacity: engineCapacity, transmission: transmission, pricePerDay: pricePerDay, freeCar: freeCar)

                self.allCars.append(car)
            }

            self.tableView.reloadData()
        }
    }

    deinit {
        if let handle = allCarsHandle {
            databaseReference.child("cars").removeObserver(withHandle: handle)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCars.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let car = allCars[indexPath.row]

        // Устанавливаем изображение с первым URL-адресом фото
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        if let firstPhotoUrl = car.photoURLs.first {
            imageView.sd_setImage(with: URL(string: firstPhotoUrl), completed: nil)
        }
        cell.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 8),
            imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 4),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: cell.contentView.bottomAnchor, constant: -4)
        ])

        // Отображаем марку, модель, carId и цену за день
        let infoStackView = UIStackView()
        infoStackView.axis = .vertical
        infoStackView.spacing = 4
        cell.contentView.addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            infoStackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 4),
            infoStackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            infoStackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -4)
        ])

        let carIdLabel = UILabel()
        carIdLabel.text = "Car ID: \(car.carId)"
        carIdLabel.font = UIFont.systemFont(ofSize: 16)
        infoStackView.addArrangedSubview(carIdLabel)

        let brandLabel = UILabel()
        brandLabel.text = car.brand
        brandLabel.font = UIFont.systemFont(ofSize: 18)
        infoStackView.addArrangedSubview(brandLabel)

        let modelLabel = UILabel()
        modelLabel.text = car.model
        modelLabel.font = UIFont.systemFont(ofSize: 18)
        infoStackView.addArrangedSubview(modelLabel)

        let priceLabel = UILabel()
        priceLabel.text = "Цена за день: \(car.pricePerDay)"
        priceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        infoStackView.addArrangedSubview(priceLabel)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCar = allCars[indexPath.row]
        let detailVC = AdminAllCarsViewDetailController()
        detailVC.car = selectedCar
        navigationController?.pushViewController(detailVC, animated: true)
    }



}
