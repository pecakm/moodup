//
//  RecipeViewController.swift
//  MoodUp Task
//
//  Created by Mikołaj Pęcak on 26.05.2017.
//  Copyright © 2017 Mikołaj Pęcak. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    // MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI() {
        // Background color
        view.backgroundColor = .white
        
        // Navigation Bar
        navigationController?.navigationBar.topItem!.title = "Pizza Recipe!"
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
