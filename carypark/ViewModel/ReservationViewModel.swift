//
//  ReservationViewModel.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import SwiftyJSON
import Alamofire
import UIKit.UIImage

class ReservationViewModel {

    func getReservation(_id: String?, completed: @escaping (Bool, Reservation?) -> Void ) {
        AF.request(Constants.serverUrl + "/reservation/",
                   method: .get,
                   parameters: [
                    "_id": _id!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let reservation = self.makeReservation(jsonItem: jsonData["reservation"])
                    completed(true, reservation)
                case let .failure(error):
                    completed(false, nil)
                }
            }
    }
    
    func addReservation(reservation: Reservation, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/reservation/",
                   method: .post,
                   parameters: [
                    "dateEntre": reservation.dateEntre!,
                    "dateSortie": reservation.dateSortie!,
                    "idPlace": reservation.idPlace!,
                    "idParking": reservation.idParking!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    completed(false)
                }
            }
    }
    
    func editReservation(reservation: Reservation, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/reservation/",
                   method: .put,
                   parameters: [
                    "_id": reservation._id!,
                    "dateEntre": reservation.dateEntre!,
                    "dateSortie": reservation.dateSortie!,
                    "idPlace": reservation.idPlace!,
                    "idParking": reservation.idParking!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    completed(false)
                }
            }
    }
    
    func deleteReservation(_id: String?, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/reservation/",
                   method: .delete,
                   parameters: [
                    "_id": _id!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    completed(false)
                }
            }
    }
    
    func makeReservation(jsonItem: JSON) -> Reservation {
        Reservation(
            _id: jsonItem["_id"].stringValue,
            dateEntre: Date(), //jsonItem["dateEntre"].stringValue,
            dateSortie: Date(), //jsonItem["dateSortie"].stringValue,
            idPlace: jsonItem["idPlace"].stringValue,
            idParking: jsonItem["idParking"].stringValue
        )
    }
}