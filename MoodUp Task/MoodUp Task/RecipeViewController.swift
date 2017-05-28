//
//  RecipeViewController.swift
//  MoodUp Task
//
//  Created by Mikołaj Pęcak on 26.05.2017.
//  Copyright © 2017 Mikołaj Pęcak. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RecipeViewController: UIViewController {

    // MARK: Properties
    var alertController = UIAlertController()
    let queue = DispatchQueue(label: "sthdfrnt")
    var scrollView = UIScrollView()
    var pizzaLabel = UILabel()
    var pizzaDescription = UITextView()
    var ingredientsLabel = UILabel()
    var ingredients = UITextView()
    var preparingLabel = UILabel()
    var preparing = UITextView()
    var imagesLabel = UILabel()
    var loginLabel = UILabel()
    var image1 = UIImageView()
    var image2 = UIImageView()
    var image3 = UIImageView()
    var longPressGesture = UILongPressGestureRecognizer()
    //var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(openActionSheet(sender:)))
        longPressGesture.minimumPressDuration = 1.0
        
        // Set view with navigation controller
        view.frame.origin.y += 64
        view.frame.size.height -= 64.0

        queue.async {
            self.getJSONData()
        }
        setUI()
        addSubviews()
    }
    
    func getJSONData() {
        Alamofire.request("http://mooduplabs.com/test/info.php").responseJSON { response in
            //print("URL: \(response.request)")  // original URL request
            //print("URL2: \(response.response)") // HTTP URL response
            //print("Server data: \(response.data)")     // server data
            //print("Response: \(response.result)")   // result of response serialization
            
            if let JSON = response.result.value {
                //print(JSON)
                self.pizzaLabel.text = "\((JSON as! NSDictionary)["title"] as! String):"
                self.pizzaDescription.text = (JSON as! NSDictionary)["description"] as! String
                for ingredient in ((JSON as! NSDictionary)["ingredients"] as! NSArray) {
                    self.ingredients.text = self.ingredients.text! + "- \(ingredient as! String)\n"
                }
                var i: Int = 1
                for step in ((JSON as! NSDictionary)["preparing"] as! NSArray) {
                    self.preparing.text = self.preparing.text! + "\(i). \(step as! String)\n"
                    i += 1
                }
                self.getImage(x: ((JSON as! NSDictionary)["imgs"] as! NSArray)[0] as! String, y: self.image1)
                self.getImage(x: ((JSON as! NSDictionary)["imgs"] as! NSArray)[1] as! String, y: self.image2)
                self.getImage(x: ((JSON as! NSDictionary)["imgs"] as! NSArray)[2] as! String, y: self.image3)
            }
        }
    }
    
    func setUI() {
        // Background color
        view.backgroundColor = .white
        
        // Navigation Bar
        navigationController?.navigationBar.topItem!.title = "Pizza Recipe!"
        
        // Pizza Label
        let pizzaLabelY: CGFloat = 20
        let pizzaLabelHeight: CGFloat = 30
        pizzaLabel = UILabel(frame: CGRect(x: 16, y: pizzaLabelY, width: view.frame.width - 32, height: pizzaLabelHeight))
        
        //Pizza description
        let pizzaDescriptionY: CGFloat = pizzaLabelY + pizzaLabelHeight
        let pizzaDescriptionHeight: CGFloat = 130
        pizzaDescription = UITextView(frame: CGRect(x: 32, y: pizzaDescriptionY, width: view.frame.width - 64, height: pizzaDescriptionHeight))
        pizzaDescription.backgroundColor = .yellow
        pizzaDescription.isEditable = false
        pizzaDescription.isScrollEnabled = false
        
        // Ingredients Label
        let ingredientsLabelY: CGFloat = pizzaDescriptionY + pizzaDescriptionHeight
        let ingredientsLabelHeight: CGFloat = 30
        ingredientsLabel = UILabel(frame: CGRect(x: 16, y: ingredientsLabelY, width: view.frame.width - 32, height: ingredientsLabelHeight))
        ingredientsLabel.text = "Ingredients:"
        
        // Ingredients
        let ingredientsY: CGFloat = ingredientsLabelY + ingredientsLabelHeight
        let ingredientsHeight: CGFloat = 150
        ingredients = UITextView(frame: CGRect(x: 32, y: ingredientsY, width: view.frame.width - 64, height: ingredientsHeight))
        ingredients.isEditable = false
        ingredients.isScrollEnabled = false
        ingredients.backgroundColor = .yellow
        
        // Preparing Label
        let preparingLabelY: CGFloat = ingredientsY + ingredientsHeight
        let preparingLabelHeight: CGFloat = 30
        preparingLabel = UILabel(frame: CGRect(x: 16, y: preparingLabelY, width: view.frame.width - 32, height: preparingLabelHeight))
        preparingLabel.text = "Preparing:"
        
        // Preparing
        let preparingY: CGFloat = preparingLabelY + preparingLabelHeight
        let preparingHeight: CGFloat = 200
        preparing = UITextView(frame: CGRect(x: 32, y: preparingY, width: view.frame.width - 64, height: preparingHeight))
        preparing.isEditable = false
        preparing.isScrollEnabled = false
        preparing.backgroundColor = .yellow
        
        // Images Label
        let imagesLabelY: CGFloat = preparingY + preparingHeight
        let imagesLabelHeight: CGFloat = 30
        imagesLabel = UILabel(frame: CGRect(x: 16, y: imagesLabelY, width: view.frame.width - 32, height: imagesLabelHeight))
        imagesLabel.text = "Images:"
        
        // Image1
        let image1Y: CGFloat = imagesLabelY + imagesLabelHeight
        let image1Height: CGFloat = 100
        image1 = UIImageView(frame: CGRect(x: 32, y: image1Y, width: view.frame.width/2 - 48, height: image1Height))
        image1.contentMode = .scaleAspectFit
        image1.isUserInteractionEnabled = true
        image1.addGestureRecognizer(longPressGesture)
        
        // Image2
        image2 = UIImageView(frame: CGRect(x: view.frame.width/2 + 16, y: image1Y, width: view.frame.width/2 - 48, height: image1Height))
        image2.contentMode = .scaleAspectFit
        
        // Image3
        let image3Y: CGFloat = image1Y + image1Height
        let image3Height: CGFloat = 100
        image3 = UIImageView(frame: CGRect(x: 32, y: image3Y, width: view.frame.width/2 - 48, height: image3Height))
        image3.contentMode = .scaleAspectFit
        
        // Scroll View
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize.height = image3Y + image3Height + 70
        
        // FB Data Box
        loginLabel = UILabel(frame: CGRect(x: 0, y: scrollView.contentSize.height - 50, width: view.frame.width, height: 50))
        loginLabel.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
        loginLabel.textAlignment = NSTextAlignment.center
        loginLabel.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        loginLabel.font = UIFont.systemFont(ofSize: 10.0)
        loginLabel.text = "Logged as \(MainViewController.GlobalVariable.name)"
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(pizzaLabel)
        scrollView.addSubview(pizzaDescription)
        scrollView.addSubview(ingredientsLabel)
        scrollView.addSubview(ingredients)
        scrollView.addSubview(preparingLabel)
        scrollView.addSubview(preparing)
        scrollView.addSubview(imagesLabel)
        scrollView.addSubview(loginLabel)
        scrollView.addSubview(image1)
        scrollView.addSubview(image2)
        scrollView.addSubview(image3)
    }
    
    func setActionSheet() {
        alertController = UIAlertController(title: "Czy zapisac?", message: nil, preferredStyle: .actionSheet)
        
        let saveImageAction = UIAlertAction(title: "Zachowaj", style: .default) { (action) -> Void in
            self.saveImage()
        }
        
        alertController.addAction(saveImageAction)
        
        let cancelAction = UIAlertAction(title: "Anuluj", style: .cancel) { (action) -> Void in
            // nic sie nie dzieje
        }
        
        alertController.addAction(cancelAction)
    }
    
    /*func addAnnotation(press: UILongPressGestureRecognizer) {
        if press.state == .began {
            self.name = "imie"
        }
    }*/
    
    func openActionSheet(sender: UILongPressGestureRecognizer) {
        setActionSheet()
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = image1
            popoverController.sourceRect = image1.frame
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getImage(x: String, y: UIImageView) {
        Alamofire.request(x).responseImage { response in
            //debugPrint(response)
            
            //print(response.request)
            //print(response.response)
            //debugPrint(response.result)
            
            if let image = response.result.value {
                //print("image downloaded: \(image)")
                y.image = image
            }
        }
    }
    
    func saveImage() {
        let imageData = UIImagePNGRepresentation(image1.image!)
        let compressedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParentViewController {
            navigationController?.navigationBar.topItem!.title = "RecipeMaster"
        }
    }
}
