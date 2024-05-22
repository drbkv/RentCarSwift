import UIKit
import ImageSlideshow
import ImageSlideshowSDWebImage
import ImageSlideshowKingfisher
import SDWebImage

class AllCarsViewDetailController: UIViewController {

    var car: Car?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var imageSlider: ImageSlider = {
        let slider = ImageSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private lazy var brandLabel: UILabel = {
        return createLabel()
    }()

    private lazy var modelLabel: UILabel = {
        return createLabel()
    }()

    private lazy var bodyTypeLabel: UILabel = {
        return createLabel()
    }()

    private lazy var colorLabel: UILabel = {
        return createLabel()
    }()

    private lazy var engineCapacityLabel: UILabel = {
        return createLabel()
    }()

    private lazy var transmissionLabel: UILabel = {
        return createLabel()
    }()

    private lazy var priceLabel: UILabel = {
        let label = createLabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private lazy var orderButton: UIButton = {
            let button = UIButton()
            button.setTitle("Заказать", for: .normal)
            button.backgroundColor = .systemBlue
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
            return button
        }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        if let car = car {
            imageSlider.imageUrls = car.photoURLs
            brandLabel.text = "Марка: \(car.brand)"
            modelLabel.text = "Модель: \(car.model)"
            bodyTypeLabel.text = "Тип кузова: \(car.bodyType)"
            colorLabel.text = "Цвет: \(car.color)"
            engineCapacityLabel.text = "Объем: \(car.engineCapacity) л"
            transmissionLabel.text = "КПП: \(car.transmission)"
            priceLabel.text = "Цена за день: $\(car.pricePerDay)"
        }

        setupUI()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageSlider)
        scrollView.addSubview(brandLabel)
        scrollView.addSubview(modelLabel)
        scrollView.addSubview(bodyTypeLabel)
        scrollView.addSubview(colorLabel)
        scrollView.addSubview(engineCapacityLabel)
        scrollView.addSubview(transmissionLabel)
        scrollView.addSubview(priceLabel)
        view.addSubview(orderButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            imageSlider.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageSlider.heightAnchor.constraint(equalToConstant: 300),

            brandLabel.topAnchor.constraint(equalTo: imageSlider.bottomAnchor, constant: 20),
            brandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            modelLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 10),
            modelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            bodyTypeLabel.topAnchor.constraint(equalTo: modelLabel.bottomAnchor, constant: 10),
            bodyTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            colorLabel.topAnchor.constraint(equalTo: bodyTypeLabel.bottomAnchor, constant: 10),
            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            engineCapacityLabel.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 10),
            engineCapacityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            transmissionLabel.topAnchor.constraint(equalTo: engineCapacityLabel.bottomAnchor, constant: 10),
            transmissionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            priceLabel.topAnchor.constraint(equalTo: transmissionLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            orderButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
                        orderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                        orderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        orderButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    @objc private func orderButtonTapped() {
        
        let orderId = UUID().uuidString // Generate a unique ID for the order
           let orderPopup = OrderPopupViewController(orderId: orderId)
           orderPopup.modalPresentationStyle = .overFullScreen
           present(orderPopup, animated: true, completion: nil)
       }
   }


class ImageSlider: UIView {
    
    var imageUrls: [String] = [] {
        didSet {
            setupImages()
        }
    }

    private lazy var slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow()
        slideshow.contentScaleMode = .scaleAspectFit
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        return slideshow
    }()

    private func setupImages() {
        var imageInputs: [ImageSource] = []
        let group = DispatchGroup()
        
        for url in imageUrls {
            group.enter()
            if let imageURL = URL(string: url) {
                let request = URLRequest(url: imageURL)
                URLSession.shared.dataTask(with: request) { data, response, error in
                    defer { group.leave() }
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            imageInputs.append(ImageSource(image: image))
                        }
                    }
                }.resume()
            }
        }
        
        group.notify(queue: .main) {
            self.slideshow.setImageInputs(imageInputs)
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        addSubview(slideshow)

        NSLayoutConstraint.activate([
            slideshow.topAnchor.constraint(equalTo: topAnchor),
            slideshow.leadingAnchor.constraint(equalTo: leadingAnchor),
            slideshow.trailingAnchor.constraint(equalTo: trailingAnchor),
            slideshow.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}
