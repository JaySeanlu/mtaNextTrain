//
//  Station.swift
//  mtaNextTrain
//
//  Created by Jason Lu on 8/29/20.
//  Copyright © 2020 Jason Lu. All rights reserved.
//

import Foundation

extension Collection {

    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

func generateSubwayRouteOrder() -> [String:Int]{
    var mappingDict : [String:Int] = [String:Int]()
    let subwayRouteOrder : [String] = ["1","2","3","4","5","6","7","A","C","E","B","D","F","M","G","J","Z","L","N","Q","R","W","S","SIR"]
    for (i, route) in subwayRouteOrder.enumerated() {
        mappingDict[route] = i
    }
    return mappingDict
}

let orderedDict: [String : Int] = generateSubwayRouteOrder()

class StationTableList: NSObject {
    var stop_name: String
    var primaryStationId: String
    var availableRoutes: [String]
    
    init(dict: [String: Any]) {
        self.stop_name = dict["stop_name"] as? String ?? ""
        self.primaryStationId = dict["primaryStationId"] as? String ?? ""
        self.availableRoutes = dict["availableRoutes"] as? [String] ?? []
    }
    
    func routesToString() -> String {
        let orderedRoutes: [String] = getOrderedRoutes()
        let stringRepresentation = orderedRoutes.joined(separator: ", ")
        return stringRepresentation
    }
    
    func getOrderedRoutes() -> [String] {
        let sortedRoutes: [String] = self.availableRoutes.sorted(by: {orderedDict[$0]! < orderedDict[$1]!})
        return sortedRoutes
    }
}

struct StationArrival: Codable {
    let stop_name: String
    let primaryStationId: String
    let availableRoutes: [String]
    let trip_updates: Arrivals
}

struct Arrivals: Codable {
    let north : [Arrival]
    let south : [Arrival]
}

struct Arrival: Codable {
    let routeId: String
    let minsETA: Int
}
