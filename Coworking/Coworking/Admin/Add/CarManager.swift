//
//  CarManager.swift
//  Coworking
//
//  Created by Ramzan on 17.05.2024.
//
import Firebase
import FirebaseDatabase
import FirebaseStorage

import UIKit
class CarManager {
    let ref = Database.database().reference().child("cars")
    
    func addCar(car: Car, images: [UIImage]) {
        let carRef = ref.childByAutoId()
        var photoURLs: [String] = []
        let dispatchGroup = DispatchGroup()
        
        for image in images {
            let imageName = UUID().uuidString + ".jpg"
            let storageRef = Storage.storage().reference().child("carImages").child(imageName)
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                dispatchGroup.enter()
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    guard let _ = metadata else {
                        // Handle error
                        dispatchGroup.leave()
                        return
                    }
                    storageRef.downloadURL { url, error in
                        if let downloadURL = url {
                            photoURLs.append(downloadURL.absoluteString)
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            carRef.setValue([
                "carId": car.carId,
                "photoURLs": photoURLs,
                "brand": car.brand,
                "model": car.model,
                "bodyType": car.bodyType,
                "color": car.color,
                "engineCapacity": car.engineCapacity,
                "transmission": car.transmission,
                "pricePerDay": car.pricePerDay,
                "freeCar": car.freeCar
            ])
        }
    }
    
    
    func getAllCars(completion: @escaping ([Car]) -> Void) {
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var cars: [Car] = []
            for case let child as DataSnapshot in snapshot.children {
                if let value = child.value as? [String: Any],
                   let carId = value["carId"] as? String,
                   let photoURLs = value["photoURLs"] as? [String],
                   let brand = value["brand"] as? String,
                   let model = value["model"] as? String,
                   let bodyType = value["bodyType"] as? String,
                   let color = value["color"] as? String,
                   let engineCapacity = value["engineCapacity"] as? String,
                   let transmission = value["transmission"] as? String,
                   let pricePerDay = value["pricePerDay"] as? Double,
                   let freeCar = value["freeCar"] as? Bool {
                    let car = Car(carId: carId, photoURLs: photoURLs, brand: brand, model: model, bodyType: bodyType, color: color, engineCapacity: engineCapacity, transmission: transmission, pricePerDay: pricePerDay, freeCar: freeCar)
                    cars.append(car)
                }
            }
            completion(cars)
        })
    }
    func editCar(carId: String, updatedData: [String: Any], images: [UIImage], completion: @escaping (Error?) -> Void) {
        guard !carId.isEmpty else {
            completion(NSError(domain: "InvalidCarId", code: 1, userInfo: [NSLocalizedDescriptionKey: "Car ID cannot be empty"]))
            return
        }

        let carRef = ref.child(carId)
        var photoURLs: [String] = []
        let dispatchGroup = DispatchGroup()

        // Upload new images and get their URLs
        for image in images {
            let imageName = UUID().uuidString + ".jpg"
            let storageRef = Storage.storage().reference().child("carImages").child(imageName)
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                dispatchGroup.enter()
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    guard let _ = metadata else {
                        // Handle error
                        dispatchGroup.leave()
                        return
                    }
                    storageRef.downloadURL { url, error in
                        if let downloadURL = url {
                            photoURLs.append(downloadURL.absoluteString)
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            print("Attempting to update car with ID \(carId)")
            // Update the existing car data
            var updatedValues = updatedData
            updatedValues["photoURLs"] = photoURLs
            carRef.updateChildValues(updatedValues) { error, _ in
                if let error = error {
                    print("Failed to update car: \(error.localizedDescription)")
                } else {
                    print("Car successfully updated")
                }
                completion(error)
            }
        }
    }

       

    func deleteCar(carId: String) {
        print("Удаление автомобиля с ID: \(carId)")
        let carRef = ref.child(carId)
        carRef.removeValue { error, _ in
            if let error = error {
                print("Ошибка при удалении автомобиля: \(error.localizedDescription)")
            } else {
                print("Автомобиль успешно удален")
            }
        }
    }
}

