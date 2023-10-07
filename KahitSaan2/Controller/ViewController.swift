//
//  Vi  ewController.swift
//    Kahit Saan
// //  Created by Jarvis Vizconde on 10/10/22.
//

import UIKit
import GooglePlaces
import CoreLocation




class ViewController: UIViewController, CLLocationManagerDelegate  {
    
    
    
    var locationManager = CLLocationManager()
    var placesManager = PlacesManager()
    
    //gms places client
    var placesClient = GMSPlacesClient()
    
    var placeModelCell = PlacesModel()
   
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var cityText: UILabel!
    @IBOutlet weak var kahitSaan: UILabel!
  
    
    @IBOutlet weak var tableViewCafe: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ask location authorization
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        placesManager.delegate = self
        locationManager.delegate = self
        
        tableViewCafe.delegate = self
        tableViewCafe.dataSource = self
        searchTextField.delegate = self
        
    }
    
    
    
 
    @IBAction func searchButton(_ sender: Any) {
        searchTextField.endEditing(true)
        
    }
    
    
    
    
    
    //MARK: - gps button
    
    @IBAction func button(_ sender: Any) {
        locationManager.startUpdatingLocation()
        
        
    }
    
    
}





//MARK: - location manager delegate

extension ViewController {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            placesManager.fetchCafes( latitude: lat , longitude: lon)
            
            
        }
        
        locationManager.stopUpdatingLocation()
        
        
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

//MARK: -  PLACESMANAGER - DELEGATE

extension ViewController : PlacesManagerDelegate {
    
    
    
    
    func didUpdateRestoLocation(_ placeManager: PlacesManager, placesModel: PlacesModel) {
        
        placeModelCell.name = placesModel.name
        placeModelCell.indexCount = placesModel.indexCount
        placeModelCell.placesID = placesModel.placesID
        placeModelCell.rating = placesModel.rating
        placeModelCell.address.removeAll()
        
        DispatchQueue.main.async {
            
            
            
            self.kahitSaan.text = "\(placesModel.name[0])"
            
            
            self.tableViewCafe.reloadData()
            
            
        }
    }
    
    func didFailWithErrorProblem(error: Error) {
        print(error)
    }
    
    
    //this updates the address on title bar
    func didaUpdatePlaceID( placeFieldID: String)  {
        
        let fields: GMSPlaceField = GMSPlaceField([ GMSPlaceField.formattedAddress ])
        
        placesClient.fetchPlace(fromPlaceID: placeFieldID , placeFields: fields, sessionToken: nil, callback: {[self]
            (place: GMSPlace?, error: Error?) in
            if  error != nil {
                print("An error occurred: \(error!.localizedDescription)")
                return
            }
            if let place = place {
                
                DispatchQueue.main.async {
                    self.cityText.text = "\(place.formattedAddress ?? "invalid address")"
                }
            }
            else {
                print("bruh we got a problem")
            }
        })
    }
    
    
    
    
}


//MARK: - table view populate

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return placeModelCell.indexCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = TableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "restoCell")
        
        let cellName = placeModelCell.name[indexPath.row]
       
        let cellAddress = placeModelCell.placesID[indexPath.row]
      
        
        //CONVERTS placeID TO ADDRESS USING GMSPLACEFIELD FROM GOOGLE
        let fields: GMSPlaceField = GMSPlaceField([ GMSPlaceField.formattedAddress ])
        
        placesClient.fetchPlace(fromPlaceID: cellAddress , placeFields: fields, sessionToken: nil, callback: { [self]
            (place: GMSPlace?, error: Error?) in
            if  error != nil {
                print("An error occurred: \(error!.localizedDescription)")
                return
            }
            if let place = place {
                //
                let addresz = String (place.formattedAddress ?? "no address")
                self.placeModelCell.address.append(addresz)
                
                
               
              
                DispatchQueue.main.async {
                    cell.detailTextLabel?.text = String (place.formattedAddress ?? "no address")
                    
                }
            }
            else {
                print("problem")
            }
        })
        
        
        
        //inputs the name and address to the tableview
       
        cell.textLabel?.text =  String (cellName)
        
        
        
        return cell
        
    }
    
    
    
    
    
}


//MARK: - TextField Delegate

extension ViewController : UITextFieldDelegate {
    
    
    
    
    
    
    //mag eend pag nag enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
       
        return true
    }
    
    
    //ivavalidate kung may laman pag nag end
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text != ""{
            return true
        }
        
        else {
            searchTextField.placeholder = "Enter a resto or location"
            return false
        }
            
        
    }
    
    //kung anong gagawin pag nag end
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let keyword = searchTextField.text {
            
          
            placesManager.fetchTextField(keywordText: keyword)
        }
        searchTextField.text = ""
    }
    
}




//MARK: - did select , segue
extension ViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SegueViewController {
            
            
            destination.segueName = placeModelCell.name[(tableViewCafe.indexPathForSelectedRow?.row)!]
            
            destination.segueAddress =  placeModelCell.address[(tableViewCafe.indexPathForSelectedRow?.row)!]
               
            destination.segueRate =   placeModelCell.rating[(tableViewCafe.indexPathForSelectedRow?.row)!]
            
           
          
            
            
           
        }
    }
}
