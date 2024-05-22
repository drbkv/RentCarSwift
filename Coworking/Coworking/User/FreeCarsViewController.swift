import UIKit
import Firebase
import SDWebImage

class FreeCarsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let databaseReference = Database.database().reference(fromURL: "https://coworkingapp-91bca-default-rtdb.asia-southeast1.firebasedatabase.app/")
    private var freeCars: [Car] = []
    private var freeCarsHandle: DatabaseHandle?

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

        observeFreeCars()
    }

    func observeFreeCars() {
        let allCarsRef = databaseReference.child("cars")
        freeCarsHandle = allCarsRef.observe(.value) { snapshot in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                print("No cars found")
                return
            }

            self.freeCars.removeAll()

            for snap in snapshots {
                guard let dict = snap.value as? [String: Any] else {
                    continue
                }

                let carId = dict["carId"] as? String ?? ""
                let photoURLs = dict["photoURLs"] as? [String] ?? []
                let brand = dict["brand"] as? String ?? ""
                let model = dict["model"] as? String ?? ""
                let pricePerDay = dict["pricePerDay"] as? Double ?? 0.0
                let freeCar = dict["freeCar"] as? Bool ?? false

                if freeCar {
                    let car = Car(carId: carId, photoURLs: photoURLs, brand: brand, model: model, bodyType: "", color: "", engineCapacity: "", transmission: "", pricePerDay: pricePerDay, freeCar: freeCar)
                    self.freeCars.append(car)
                }
            }

            self.tableView.reloadData()
        }
    }

    deinit {
        if let handle = freeCarsHandle {
            databaseReference.child("cars").removeObserver(withHandle: handle)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freeCars.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let car = freeCars[indexPath.row]

        // Создаем контейнер для фото и информации
        let containerStackView = UIStackView()
        containerStackView.axis = .horizontal
        containerStackView.spacing = 8
        containerStackView.alignment = .center
        cell.contentView.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 8),
            containerStackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 4),
            containerStackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            containerStackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -4)
        ])

        // Setup imageView with first photoURL
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        if let firstPhotoUrl = car.photoURLs.first {
            imageView.sd_setImage(with: URL(string: firstPhotoUrl), completed: nil)
        }
        containerStackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.4), // Уменьшаем ширину в 2.5 раза
            imageView.heightAnchor.constraint(equalToConstant: 100) // Устанавливаем фиксированную высоту
        ])

        // Создаем стек для информации справа от фото
        let infoStackView = UIStackView()
        infoStackView.axis = .vertical
        infoStackView.spacing = 4
        containerStackView.addArrangedSubview(infoStackView)

        let brandLabel = UILabel()
        brandLabel.text = car.brand
        brandLabel.font = UIFont.systemFont(ofSize: 18) // Уменьшаем размер шрифта
        infoStackView.addArrangedSubview(brandLabel)

        let modelLabel = UILabel()
        modelLabel.text = car.model
        modelLabel.font = UIFont.systemFont(ofSize: 18) // Уменьшаем размер шрифта
        infoStackView.addArrangedSubview(modelLabel)

        let priceLabel = UILabel()
        priceLabel.text = "Price per day: \(car.pricePerDay)"
        priceLabel.font = UIFont.boldSystemFont(ofSize: 20) // Устанавливаем
        infoStackView.addArrangedSubview(priceLabel)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let selectedCar = freeCars[indexPath.row]
            let detailVC = AllCarsViewDetailController()
            detailVC.car = selectedCar
            navigationController?.pushViewController(detailVC, animated: true)
        }

}
