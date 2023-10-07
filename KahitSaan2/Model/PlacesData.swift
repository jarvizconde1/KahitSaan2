//
//  PlacesData.swift
//  Kahit Saan
//
//  Created by Jarvis Vizconde on 10/18/22.
//

import Foundation

struct PlacesData : Codable {
    
   
    let results : [Results]
    
  
}


struct Results : Codable {
    
    
    //make sure na yung name same sa path ng JSON
 

    let name : String
    let place_id : String
   
    let rating : Float?
   
    
}







