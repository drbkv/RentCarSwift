import UIKit
import ImageSlideshow
import Firebase

class AdminViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let carManager = CarManager()

    private lazy var slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow()
        slideshow.backgroundColor = .lightGray
        slideshow.contentScaleMode = .scaleAspectFill
        slideshow.clipsToBounds = true
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.slideshowInterval = 0
        return slideshow
    }()

    private lazy var brandTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Brand"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var modelTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Model"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var bodyTypeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Sedan", "SUV", "Truck"])
        return segmentedControl
    }()

    private lazy var colorTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Color"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var engineCapacityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Engine Capacity"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var transmissionSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Automatic", "Manual"])
        return segmentedControl
    }()

    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Price"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var freeCarSwitch: UISwitch = {
        let switchControl = UISwitch()
        return switchControl
    }()

    private lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Photo", for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveButtonTapped1(_:)), for: .touchUpInside)
        return button
    }()

    private var imageSources: [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(slideshow)
        view.addSubview(brandTextField)
        view.addSubview(modelTextField)
        view.addSubview(bodyTypeSegmentedControl)
        view.addSubview(colorTextField)
        view.addSubview(engineCapacityTextField)
        view.addSubview(transmissionSegmentedControl)
        view.addSubview(priceTextField)
        view.addSubview(freeCarSwitch)
        view.addSubview(addPhotoButton)
        view.addSubview(saveButton); slideshow.translatesAutoresizingMaskIntoConstraints = false
        brandTextField.translatesAutoresizingMaskIntoConstraints = false
        modelTextField.translatesAutoresizingMaskIntoConstraints = false
        bodyTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        colorTextField.translatesAutoresizingMaskIntoConstraints = false
        engineCapacityTextField.translatesAutoresizingMaskIntoConstraints = false
        transmissionSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        freeCarSwitch.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        setupConstraints()

        // Get the current user's UID

    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            slideshow.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            slideshow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slideshow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            slideshow.heightAnchor.constraint(equalToConstant: 100),

            brandTextField.topAnchor.constraint(equalTo: slideshow.bottomAnchor, constant: 10),
            brandTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            brandTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            brandTextField.heightAnchor.constraint(equalToConstant: 20),

            modelTextField.topAnchor.constraint(equalTo: brandTextField.bottomAnchor, constant: 10),
            modelTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            modelTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            modelTextField.heightAnchor.constraint(equalToConstant: 20),

            bodyTypeSegmentedControl.topAnchor.constraint(equalTo: modelTextField.bottomAnchor, constant: 10),
            bodyTypeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bodyTypeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bodyTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 20),

            colorTextField.topAnchor.constraint(equalTo: bodyTypeSegmentedControl.bottomAnchor, constant: 10),
            colorTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            colorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            colorTextField.heightAnchor.constraint(equalToConstant: 20),

            engineCapacityTextField.topAnchor.constraint(equalTo: colorTextField.bottomAnchor, constant: 10),
            engineCapacityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            engineCapacityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            engineCapacityTextField.heightAnchor.constraint(equalToConstant: 20),

            transmissionSegmentedControl.topAnchor.constraint(equalTo: engineCapacityTextField.bottomAnchor, constant: 10),
            transmissionSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transmissionSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            transmissionSegmentedControl.heightAnchor.constraint(equalToConstant: 20),

            priceTextField.topAnchor.constraint(equalTo: transmissionSegmentedControl.bottomAnchor, constant: 10),
            priceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            priceTextField.heightAnchor.constraint(equalToConstant: 20),

            freeCarSwitch.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 10),
            freeCarSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            addPhotoButton.topAnchor.constraint(equalTo: freeCarSwitch.bottomAnchor, constant: 10),
            addPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 20),

            saveButton.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 10),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    @objc private func addPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageSources.append(image)
            slideshow.setImageInputs(imageSources.map { ImageSource(image: $0) })
        }
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped1(_ sender: UIButton) {
        guard let brand = brandTextField.text, !brand.isEmpty,
              let model = modelTextField.text, !model.isEmpty,
              let color = colorTextField.text, !color.isEmpty,
              let engineCapacity = engineCapacityTextField.text, !engineCapacity.isEmpty,
              let priceText = priceTextField.text, let price = Double(priceText), price > 0
        else {
            // Show a warning or error message
            return
        }

        let bodyType = bodyTypeSegmentedControl.titleForSegment(at: bodyTypeSegmentedControl.selectedSegmentIndex) ?? ""
        let transmission = transmissionSegmentedControl.titleForSegment(at: transmissionSegmentedControl.selectedSegmentIndex) ?? ""
        let freeCar = freeCarSwitch.isOn

        let carId = UUID().uuidString
        let car = Car(carId: carId, photoURLs: [], brand: brand, model: model, bodyType: bodyType, color: color, engineCapacity: engineCapacity, transmission: transmission, pricePerDay: price, freeCar: freeCar)
        carManager.addCar(car: car, images: imageSources)

        // Clear fields
        brandTextField.text = ""
        modelTextField.text = ""
        colorTextField.text = ""
        engineCapacityTextField.text = ""
        priceTextField.text = ""
        clearPhotos()
    }

    private func clearPhotos() {
        imageSources.removeAll()
        slideshow.setImageInputs([])
    }
}

