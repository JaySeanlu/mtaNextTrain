//
//  ViewController.swift
//  mtaNextTrain
//
//  Created by Jason Lu on 8/26/20.
//  Copyright © 2020 Jason Lu. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var isNumeric : Bool {
        return Double(self) != nil
    }
}

class StationListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!

    var stationContainer : [[StationTableList]] = [[StationTableList]](repeating: [], count: 27)
    var stationSearchResults: [[StationTableList]] = [[StationTableList]](repeating: [], count: 27)
        
    func getHashIndex(full_name: String) -> Int {
        let firstLetter : String = String(full_name.prefix(1))
        if(firstLetter.isNumeric) {
            return 0;
        }
        let firstLetterChar = Character(firstLetter.uppercased())
        
        if(firstLetterChar.isLetter) {
            let asciiInt = Int(firstLetterChar.asciiValue!)
            let indexScalar : Int = 64
            return asciiInt - indexScalar
        }
        return 666;
    }

    //helper function to setup the sectionsStationContainer
    func genSectionHeader(n : Int) -> String {
        if n == 0 {
            return "#"
        }
        let starter : Int = Int(("A" as UnicodeScalar).value)
        return String(UnicodeScalar(n-1 + starter)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.showsCancelButton = false
        searchBar.delegate = self
                
        let url = URL(string: "https://mtanexttrain.herokuapp.com/stations")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("API Response Failed")
                print(error!)
                return
            }

            guard let payload = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("not a JSON object")
                return
            }
            
            let values = Array(payload.values)
            
            for v in values {
                let currStation:StationTableList = StationTableList(dict: v as! [String: Any])
                                
                //append the sections container here
                let hashIndex = self.getHashIndex(full_name: currStation.stop_name)
                
                self.stationContainer[hashIndex].append(currStation)
            }
            
            for (index,container) in self.stationContainer.enumerated() {
                self.stationContainer[index] = container.sorted {$0.stop_name < $1.stop_name}
            }
            
            self.stationSearchResults = self.stationContainer
        
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        stationSearchResults = [[StationTableList]](repeating: [], count: 27)
        
        searchBar.showsCancelButton = true
        if searchText.count == 0
        {
            stationSearchResults = stationContainer
            tableView.reloadData()
        }
        
        else {
            for i in 0...stationContainer.count-1 {
                var filteredStations: [StationTableList] = []
                for station in stationContainer[i] {
                    if station.stop_name.lowercased().contains(searchText.lowercased()) {
                        filteredStations.append(station)
                    }
                }
                stationSearchResults[i] = filteredStations
            }
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        // Remove focus from the search bar.
        searchBar.endEditing(true)
        
        stationSearchResults = stationContainer
        tableView.reloadData()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return stationSearchResults.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return stationSearchResults[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if stationSearchResults[section].count == 0 {
            return nil
        }
        return self.genSectionHeader(n: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath)
        cell.textLabel?.text = stationSearchResults[indexPath.section][indexPath.row].stop_name
        cell.detailTextLabel?.text = stationSearchResults[indexPath.section][indexPath.row].routesToString()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ETAView" {
            //the variable will return nill if the segue destination isn't a PokemonViewController
            if let destination = segue.destination as? ETAViewController {
                //Gets the item for the row that the user just selected in the previous TableViewController
                destination.targetStation = stationSearchResults[tableView.indexPathForSelectedRow!.section][tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}

