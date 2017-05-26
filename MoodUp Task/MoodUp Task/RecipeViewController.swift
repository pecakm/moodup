//
//  RecipeViewController.swift
//  MoodUp Task
//
//  Created by Mikołaj Pęcak on 26.05.2017.
//  Copyright © 2017 Mikołaj Pęcak. All rights reserved.
//

import UIKit
import Alamofire

class RecipeViewController: UIViewController {

    // MARK: Properties
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set view with navigation controller
        view.frame.origin.y += 64
        view.frame.size.height -= 64.0
        
        setUI()
        getData()
        
    }
    
    func setUI() {
        // Background color
        view.backgroundColor = .white
        
        // Navigation Bar
        navigationController?.navigationBar.topItem!.title = "Pizza Recipe!"
    }
    
    func getData() {
        Alamofire.request("http://mooduplabs.com/test/info.php").responseJSON { response in
            print("URL: \(response.request)")  // original URL request
            print("URL2: \(response.response)") // HTTP URL response
            print("Server data: \(response.data)")     // server data
            print("Response: \(response.result)")   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParentViewController {
            navigationController?.navigationBar.topItem!.title = "RecipeMaster"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
