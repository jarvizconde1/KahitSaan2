//
//  PlacesManager.swift
//  Kahit Saan
//
//  Created by Jarvis Vizconde on 10/17/22.
//

import Foundation
import UIKit

protocol PlacesManagerDelegate {
    func didUpdateRestoLocation (  _ placeManager : PlacesManager , placesModel : PlacesModel   )
    func didFailWithErrorProblem ( error : Error)
    func didaUpdatePlaceID (placeFieldID : String )

}




struct PlacesManager {
    
    
    var delegate : PlacesManagerDelegate?
    
    let nearbyURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?&key=AIzaSyDuWpaiB93twCQyo68E3J_9MIINRWh8OSg&rankby=distance&type=food|restaurant|bakery|cafe&location="
    
    let textFieldURL = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyDuWpaiB93twCQyo68E3J_9MIINRWh8OSg&type=food|restaurant|bakery|cafe&query="
    
    
    
    
    
    //THIS WILL ADD THE LAT AND LONG TO END OF THE URL - gps button
    func fetchCafes( latitude: Double , longitude: Double ) {
        
        let fullUrlString = "\(nearbyURL)\(latitude),\(longitude)"
        
        print(fullUrlString)
        
        
        if let finalURL =  fullUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            print(finalURL)
            performRequest(with: finalURL)
        }
        
        else {
            print("Problem on URL")
        }
        
        
        
    }
    
    
    
    
    //fetch searchbar
    func fetchTextField ( keywordText : String) {
        
        
        let fullUrlString = "\(textFieldURL)\(keywordText)"
        
        print(fullUrlString)
        
        
        if let finalURL =  fullUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            print(finalURL)
            performRequest(with: finalURL)
        }
        
        else {
            print("Problem on URL")
        }
        
        
        
        
        
     
       
       
        
    }
    
    
    
    
    
    
    
    func performRequest(with urlString : String) {
        
        
        
        // 1. Create URL
        if  let urlA = URL(string: urlString) {
            
            
            
            //2, Create URL session
            let session = URLSession(configuration: .default)
            
            
            //3. Give the session a task
            let task = session.dataTask(with: urlA ) {( data, response, errorz) in
                
                
                //check kung may error pag meron iprint na then end
                if errorz != nil {
                    
                    
                    // self.delegate?.didFailWithErrorProblem(error : errorz!)
                    
                    delegate?.didFailWithErrorProblem(error: errorz!)
                    
                    
                    print("ERROR BRUH")
                    //if gusto mo customized ung error
                    //    self.delegate?.didFailWithError(errorrs: "asdas" as! Error)
                    
                    
                    return  // skip na or end
                }
                
                if let safeData = data {
                    
                    if  let restoDetails  =  self.parseJSON(parsingData: safeData) {
                        
                        
                        
                        //updating the front page title and address
                        self.delegate?.didUpdateRestoLocation( self, placesModel: restoDetails)
                        
                        self.delegate?.didaUpdatePlaceID( placeFieldID: restoDetails.placesID[0])
                        
                       
                        
                        
                        
                        
                        
                    }
                    
                }
            }
            
            
            //4. Start the task
            task.resume()
            
        }
        
    }
    
    
    
    func parseJSON(  parsingData: Data) -> PlacesModel? {
        
        // initialize ung decoder ()
        let decoder = JSONDecoder()
        
        
        do {
            let decodedData =  try decoder.decode( PlacesData.self , from : parsingData)
            
            
            
            //details for array - will be used for cell details
            var restoCount = decodedData.results.count
            
            var cellRestoName : [String] = []
            var cellPlacesID : [String] = []
          
            var cellRating : [Float] = []
           
            
            
            //
            
            
            var counter : Int = 0
            
       for _ in 1...restoCount {
                
                cellRestoName.append(String(decodedData.results[counter].name))
                cellPlacesID.append(String(decodedData.results[counter].place_id))
                cellRating.append(decodedData.results[counter].rating ?? 0)
    
                counter  += 1
             
            }
            restoCount -= 1
            
            
            
          
            
            //put data to PlacesModel  and cellModel
            let restoDetails = PlacesModel(name: cellRestoName,placesID: cellPlacesID, rating : cellRating ,indexCount: restoCount)
            
            
            print(restoDetails)
            
            
       
            
            return restoDetails
            
            
            
            
            
            
            
            
            
            
            
        }
        
        catch {
            delegate?.didFailWithErrorProblem(error: error)
            
            return nil
        }
    }
}


