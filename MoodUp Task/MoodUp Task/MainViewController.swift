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
    var menuButton = UIButton(type: .contactAdd)
    var loginLabel = UILabel()
    var name = ""
    var profileImageURL = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if AccessToken.current != nil {
            getFBData()
        }
        
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
        imageView.backgroundColor = .white
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
        menuButton.frame.origin = CGPoint(x: view.frame.width - 40, y: view.frame.height - 40)
        menuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        view.addSubview(menuButton)
        
        // FBData Box
        if AccessToken.current != nil {
            loginLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50))
            loginLabel.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
            loginLabel.textAlignment = NSTextAlignment.center
            loginLabel.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
            loginLabel.text = "Logged as \(self.name)"
            loginLabel.font = UIFont.systemFont(ofSize: 10.0)
            view.addSubview(loginLabel)
            
            menuButton.frame.origin = CGPoint(x: view.frame.width - 40, y: view.frame.height - 90)
        }
    }
    
    func setActionSheet() {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let getRecipeAction = UIAlertAction(title: "Get the Recipe", style: .default) { (action) -> Void in
            self.getTheRecipe()
        }
        
        alertController.addAction(getRecipeAction)
        
        if AccessToken.current == nil {
            let logInFbAction = UIAlertAction(title: "Zaloguj przez Facebooka", style: .default) { (action) -> Void in
                self.loginButtonClicked()
            }
            
            alertController.addAction(logInFbAction)
        }
        else {
            let logOutFbAction = UIAlertAction(title: "Wyloguj", style: .default) { (action) -> Void in
                print("Logged out!")
                LoginManager().logOut()
                self.loginLabel.removeFromSuperview()
                self.setUI()
                self.setActionSheet()
            }
            
            alertController.addAction(logOutFbAction)
        }
        
        let closeMenuAction = UIAlertAction(title: "Ukryj menu", style: .cancel) { (action) -> Void in
            print("cancel")
        }
        
        alertController.addAction(closeMenuAction)
    }
    
    func showMenu(sender: UIButton) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getTheRecipe() {
        if AccessToken.current != nil {
            print("Accept")
        }
        else {
            self.loginButtonClicked()
        }
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
                self.getFBData()
                self.setUI()
                self.setActionSheet()
            }
        }
    }
    
    func getFBData() {
        let params = ["fields" : "name, picture"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    self.name = responseDictionary["name"] as! String!
                    self.profileImageURL = (((responseDictionary["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String)!
                }
            }
        }
    }
    
    func setFBDataBox() {
        
    }
}

