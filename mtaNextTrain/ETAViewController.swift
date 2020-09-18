//
//  ETAViewController.swift
//  mtaNextTrain
//
//  Created by Jason Lu on 9/6/20.
//  Copyright © 2020 Jason Lu. All rights reserved.
//

import UIKit

class ETAViewController: UIViewController {
    
    var targetStation: StationTableList!
    var stationArrivals: Arrivals?
    @IBOutlet var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = targetStation.stop_name
        
        self.loadStationETA(stationId: targetStation.primaryStationId) {(output) in
            self.stationArrivals = output
            
            DispatchQueue.main.async {
              self.performSegue(withIdentifier: "ToFirstChild", sender: nil)
              self.performSegue(withIdentifier: "ToSecondChild", sender: nil)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToFirstChild" {
            if let destination = segue.destination as? northBoundArrivals {
                destination.northArrivals = self.stationArrivals?.north
            }
        }
            
        else if segue.identifier == "ToSecondChild" {
            if let destination = segue.destination as? southBoundArrivals {
                destination.southArrivals = stationArrivals?.south
            }
        }

    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    
    func loadStationETA(stationId: String, completionBlock: @escaping (Arrivals) -> Void) -> Void {
        let apiString:String = "https://mtanexttrain.herokuapp.com/arrivals/KxBKHDPVY3byuiLv8G4629ukwRY90oo7SyjFSUcf/station/" + stationId
        
        let url = URL(string: apiString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("API Response Failed")
                return
            }
            
            do {
                let payload = try JSONDecoder().decode(StationArrival.self, from:data)
                
                let arrivalsContainer: Arrivals = payload.trip_updates
                completionBlock(arrivalsContainer)
            }
            
            catch let error {
                print("\(error)")
            }
        }.resume()
    }
}
