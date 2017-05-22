//
//  MainViewController.swift
//  MoodUp Task
//
//  Created by Mikołaj Pęcak on 19.05.2017.
//  Copyright © 2017 Mikołaj Pęcak. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class MainViewController: UIViewController {
    
    // MARK: Properties
    var alertController: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUI()
        setActionSheet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Functions

    func setUI() {
        // Status Bar
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 211/255, green: 46/255, blue: 46/255, alpha: 1.0)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
        // Navigation Bar
        let topSpacing: CGFloat = 20
        let navigationHeight: CGFloat = 44
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: topSpacing, width: view.frame.width, height: navigationHeight))
        view.addSubview(navigationBar)
        
        // Navigation Label
        let navigationLabel = UILabel(frame: CGRect(x: 20, y: topSpacing, width: view.frame.width, height: navigationHeight))
        navigationLabel.textColor = UIColor.white
        navigationLabel.text = "RecipeMaster"
        navigationLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        view.addSubview(navigationLabel)
        
        // Round image
        let imageRadius: CGFloat = 100
        let imageView = UIImageView(frame: CGRect(x: view.frame.width/2 - imageRadius, y: view.frame.height/2 - imageRadius, width: imageRadius * 2, height: imageRadius * 2))
        imageView.image = #imageLiteral(resourceName: "centerImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageRadius
        imageView.clipsToBounds = true
        imageView.alpha = 0.5
        view.addSubview(imageView)
        
        // Center Label
        let centerLabel = UILabel(frame: CGRect(x: view.frame.width/2 - imageRadius, y: view.frame.height/2 - imageRadius, width: imageRadius * 2, height: imageRadius * 2))
        centerLabel.textAlignment = NSTextAlignment.center
        centerLabel.text = "RecipeMaster"
        centerLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        view.addSubview(centerLabel)
        
        // MenuButton
        let menuButton = UIButton(type: .contactAdd)
        menuButton.frame.origin = CGPoint(x: view.frame.width - 40, y: view.frame.height - 40)
        menuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        view.addSubview(menuButton)
    }
    
    func setActionSheet() {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let getRecipeAction = UIAlertAction(title: "Get the Recipe", style: .default) { (action) -> Void in
            
        }
        
        let logInByFbAction = UIAlertAction(title: "Zaloguj przez Facebooka", style: .default) { (action) -> Void in
            self.loginButtonClicked()
        }
        
        let closeMenuAction = UIAlertAction(title: "Ukryj menu", style: .cancel) { (action) -> Void in
            print("cancel")
        }
        
        alertController.addAction(getRecipeAction)
        alertController.addAction(logInByFbAction)
        alertController.addAction(closeMenuAction)
    }
    
    func showMenu(sender: UIButton) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getTheRecipe() {
        
    }
    
    func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
            }
        }
    }
}

