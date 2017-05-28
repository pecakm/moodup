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
    
    // Variables used in another class
    struct GlobalVariable {
        static var name = ""
        static var profileImageURL = ""
    }
    
    // MARK: Properties
    let queue = DispatchQueue(label: "que")
    var scrollView = UIScrollView()
    var navigationLabel = UILabel()
    var imageView = UIImageView()
    var centerLabel = UILabel()
    var menuButton = UIButton(type: .contactAdd)
    var loginLabel = UILabel()
    var alertController: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if AccessToken.current != nil {
            getFBData()
        }
        
        // Set view with navigation controller
        view.frame.origin.y += 64
        view.frame.size.height -= 64.0
        
        setUI()
        addSubviews()
        setActionSheet()
    }
    
    // MARK: Functions

    func setUI() {
        // Navigation Bar
        navigationController?.navigationBar.topItem!.title = "RecipeMaster"
        
        // Round image
        let imageRadius: CGFloat = 100
        imageView = UIImageView(frame: CGRect(x: view.frame.width/2 - imageRadius, y: view.frame.height/2 - imageRadius - 30, width: imageRadius * 2, height: imageRadius * 2))
        imageView.image = #imageLiteral(resourceName: "centerImage")
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageRadius
        imageView.clipsToBounds = true
        imageView.alpha = 0.5
        
        // Center Label
        centerLabel = UILabel(frame: CGRect(x: view.frame.width/2 - imageRadius, y: view.frame.height/2 - imageRadius - 30, width: imageRadius * 2, height: imageRadius * 2))
        centerLabel.textAlignment = NSTextAlignment.center
        centerLabel.text = "RecipeMaster"
        centerLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        
        // MenuButton
        menuButton.frame.origin = CGPoint(x: view.frame.width - 40, y: view.frame.height - 40)
        menuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        
        // FBData Box
        if AccessToken.current != nil {
            loginLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50))
            loginLabel.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
            loginLabel.textAlignment = NSTextAlignment.center
            loginLabel.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
            loginLabel.font = UIFont.systemFont(ofSize: 10.0)
            view.addSubview(loginLabel)
            
            menuButton.frame.origin = CGPoint(x: view.frame.width - 40, y: view.frame.height - 90)
        }
    }
    
    func addSubviews() {
        view.addSubview(navigationLabel)
        view.addSubview(imageView)
        view.addSubview(centerLabel)
        view.addSubview(menuButton)
    }
    
    func setActionSheet() {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let getRecipeAction = UIAlertAction(title: "Get the Recipe", style: .default) { (action) -> Void in
            if AccessToken.current != nil {
                //let newViewController = RecipeViewController()
                self.navigationController?.pushViewController(RecipeViewController(), animated: true)
            }
            else {
                let alert = UIAlertController(title: "Ooops!", message: "Zaloguj się, aby obejrzeć przepis!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
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
            // Nothing happens
        }
        
        alertController.addAction(closeMenuAction)
    }
    
    func showMenu(sender: UIButton) {
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loginButtonClicked() -> Bool {
        var flag = false
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
                flag = true
            }
        }
        
        return flag
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
                    self.loginLabel.text = "Logged as \(responseDictionary["name"] as! String)"
                    GlobalVariable.name = responseDictionary["name"] as! String
                    GlobalVariable.profileImageURL = (((responseDictionary["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String)!
                }
            }
        }
    }
}

