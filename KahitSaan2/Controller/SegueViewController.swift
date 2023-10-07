//
//  SegueViewController.swift
//  Kahit Saan
//
//  Created by Jarvis Vizconde on 11/11/22.
//

import UIKit

class SegueViewController: UIViewController {

    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var rate: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    var segueName       : String?
    var segueAddress : String?
    var segueRate     : Float?
   //var
    
    
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text =     segueName
        address.text = segueAddress
        rate.text =  String(format: "%.2f", segueRate!)
       // status.text =
       
    }



}
