struct Car {
    let carId: String
    var photoURLs: [String]
    var brand: String
    var model: String
    var bodyType: String
    var color: String
    var engineCapacity: String
    var transmission: String
    var pricePerDay: Double
    var freeCar: Bool
    
    init(carId: String, photoURLs: [String], brand: String, model: String, bodyType: String, color: String, engineCapacity: String, transmission: String, pricePerDay: Double, freeCar: Bool = true) {
        self.carId = carId
        self.photoURLs = photoURLs
        self.brand = brand
        self.model = model
        self.bodyType = bodyType
        self.color = color
        self.engineCapacity = engineCapacity
        self.transmission = transmission
        self.pricePerDay = pricePerDay
        self.freeCar = freeCar
    }
}
