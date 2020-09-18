//
//  NorthSouthArrivalViewController.swift
//  mtaNextTrain
//
//  Created by Jason Lu on 9/16/20.
//  Copyright © 2020 Jason Lu. All rights reserved.
//

import UIKit

func getTopFour(arrivals: [Arrival]) -> [Arrival]{
    let lengthArrivals = 4
    if arrivals.count >= lengthArrivals {
        return Array(arrivals[0 ..< lengthArrivals])
    }
    return arrivals
}

func generateSubwayImageMapping() -> [String: UIImage] {
    var mappingDict : [String:UIImage] = [String:UIImage]()
    let subwayRouteOrder : [String] = ["1","2","3","4","5","6","6X","7","7X","A","C","E","H", "B","D","F","M","G","J","Z","L","N","Q","R","W","S","SIR"]
    for route in subwayRouteOrder {
        mappingDict[route] = UIImage(named: route.lowercased())
    }
    
    return mappingDict
}

let routeImageMapping: [String : UIImage] = generateSubwayImageMapping()

class northBoundArrivals: UITableViewController {
    
    var northArrivals: [Arrival]!
    var northTop4Arrivals: [Arrival]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.alwaysBounceVertical = false
        tableView.allowsSelection = false
        
        self.northTop4Arrivals = getTopFour(arrivals: self.northArrivals!)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "▲  Northbound"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.northTop4Arrivals.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NorthETACell", for: indexPath)
        let targetCell: Arrival = self.northTop4Arrivals![indexPath.row]
        
        let cellImg : UIImageView = UIImageView(frame: CGRect(x: 15 , y: 15, width: 35, height: 35))
        cellImg.image = routeImageMapping[targetCell.routeId]
        
        
        let cellText =  UITextField(frame: CGRect(x: 65, y: 15, width: 300, height: 40))
        cellText.text = "\(targetCell.minsETA) mins"
        
        cell.addSubview(cellText)
        cell.addSubview(cellImg)
        return cell
    }
}

class southBoundArrivals: UITableViewController {
    
    var southArrivals: [Arrival]!
    var southTop4Arrivals: [Arrival]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.alwaysBounceVertical = false
        tableView.allowsSelection = false
        
        self.southTop4Arrivals = getTopFour(arrivals: self.southArrivals!)

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "▼  Southbound"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.southTop4Arrivals.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SouthETACell", for: indexPath)
        let targetCell: Arrival = self.southTop4Arrivals![indexPath.row]
        
        let cellImg : UIImageView = UIImageView(frame: CGRect(x: 15 , y: 15, width: 35, height: 35))
        cellImg.image = routeImageMapping[targetCell.routeId]
        
        let cellText =  UITextField(frame: CGRect(x: 65, y: 15, width: 300, height: 40))
        cellText.text = "\(targetCell.minsETA) mins"
        
        cell.addSubview(cellText)
        cell.addSubview(cellImg)
        return cell
    }
}

