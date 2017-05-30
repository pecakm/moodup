import UIKit
import Alamofire
import AlamofireImage

class RecipeViewController: UIViewController {

    // MARK: Properties
    var alertController = UIAlertController()
    let queue = DispatchQueue(label: "queue")
    var scrollView = UIScrollView()
    var titleLabel = UILabel()
    var titleDescription = UITextView()
    var ingredientsLabel = UILabel()
    var ingredients = UITextView()
    var preparingLabel = UILabel()
    var preparing = UITextView()
    var imagesLabel = UILabel()
    var loginLabel = UILabel()
    var imageViews = [UIImageView]()
    var image1 = UIImageView()
    var image2 = UIImageView()
    var image3 = UIImageView()
    var longPressGesture1 = UILongPressGestureRecognizer()
    var longPressGesture2 = UILongPressGestureRecognizer()
    var longPressGesture3 = UILongPressGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set press gestures
        longPressGesture1 = UILongPressGestureRecognizer(target: self, action: #selector(openActionSheet(sender:)))
        longPressGesture1.minimumPressDuration = 1.0
        
        // Set array of images
        imageViews = [image1, image2, image3]
        
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
            if let JSON = response.result.value {
                self.titleLabel.text = "\((JSON as! NSDictionary)["title"] as! String):"
                self.titleDescription.text = (JSON as! NSDictionary)["description"] as! String
                for ingredient in ((JSON as! NSDictionary)["ingredients"] as! NSArray) {
                    self.ingredients.text = self.ingredients.text! + "- \(ingredient as! String)\n"
                }
                var i: Int = 1
                for step in ((JSON as! NSDictionary)["preparing"] as! NSArray) {
                    self.preparing.text = self.preparing.text! + "\(i). \(step as! String)\n\n"
                    i += 1
                }
                for i in 0...2 {
                    self.getImage(imageURL: (((JSON as! NSDictionary)["imgs"] as! NSArray)[i] as! String), imageView: self.imageViews[i])
                }
            }
        }
    }
    
    func setUI() {
        // Background color
        view.backgroundColor = .white
        
        // Navigation Bar
        navigationController?.navigationBar.topItem!.title = "Pizza Recipe!"
        
        // Title Label
        let titleLabelY: CGFloat = 20
        let titleLabelHeight: CGFloat = 30
        titleLabel = UILabel(frame: CGRect(x: 16, y: titleLabelY, width: view.frame.width - 32, height: titleLabelHeight))
        
        //Pizza description
        let titleDescriptionY: CGFloat = titleLabelY + titleLabelHeight
        let titleDescriptionHeight: CGFloat = 130
        titleDescription = UITextView(frame: CGRect(x: 32, y: titleDescriptionY, width: view.frame.width - 64, height: titleDescriptionHeight))
        titleDescription.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        titleDescription.isEditable = false
        titleDescription.isScrollEnabled = false
        
        // Ingredients Label
        let ingredientsLabelY: CGFloat = titleDescriptionY + titleDescriptionHeight
        let ingredientsLabelHeight: CGFloat = 30
        ingredientsLabel = UILabel(frame: CGRect(x: 16, y: ingredientsLabelY, width: view.frame.width - 32, height: ingredientsLabelHeight))
        ingredientsLabel.text = "Ingredients:"
        
        // Ingredients
        let ingredientsY: CGFloat = ingredientsLabelY + ingredientsLabelHeight
        let ingredientsHeight: CGFloat = 150
        ingredients = UITextView(frame: CGRect(x: 32, y: ingredientsY, width: view.frame.width - 64, height: ingredientsHeight))
        ingredients.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        ingredients.isEditable = false
        ingredients.isScrollEnabled = false
        
        // Preparing Label
        let preparingLabelY: CGFloat = ingredientsY + ingredientsHeight
        let preparingLabelHeight: CGFloat = 30
        preparingLabel = UILabel(frame: CGRect(x: 16, y: preparingLabelY, width: view.frame.width - 32, height: preparingLabelHeight))
        preparingLabel.text = "Preparing:"
        
        // Preparing
        let preparingY: CGFloat = preparingLabelY + preparingLabelHeight
        let preparingHeight: CGFloat = 280
        preparing = UITextView(frame: CGRect(x: 32, y: preparingY, width: view.frame.width - 64, height: preparingHeight))
        preparing.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        preparing.isEditable = false
        preparing.isScrollEnabled = false
        
        // Images Label
        let imagesLabelY: CGFloat = preparingY + preparingHeight
        let imagesLabelHeight: CGFloat = 30
        imagesLabel = UILabel(frame: CGRect(x: 16, y: imagesLabelY, width: view.frame.width - 32, height: imagesLabelHeight))
        imagesLabel.text = "Images:"
        
        // Image1
        let image1Y: CGFloat = imagesLabelY + imagesLabelHeight
        let image1Height: CGFloat = 100
        imageViews[0] = UIImageView(frame: CGRect(x: 32, y: image1Y, width: view.frame.width/2 - 48, height: image1Height))
        imageViews[0].contentMode = .scaleAspectFit
        imageViews[0].isUserInteractionEnabled = true
        imageViews[0].addGestureRecognizer(longPressGesture1)
        
        // Image2
        imageViews[1] = UIImageView(frame: CGRect(x: view.frame.width/2 + 16, y: image1Y, width: view.frame.width/2 - 48, height: image1Height))
        imageViews[1].contentMode = .scaleAspectFit
        imageViews[1].isUserInteractionEnabled = true
        imageViews[1].addGestureRecognizer(longPressGesture2)
        
        // Image3
        let image3Y: CGFloat = image1Y + image1Height
        let image3Height: CGFloat = 100
        imageViews[2] = UIImageView(frame: CGRect(x: 32, y: image3Y, width: view.frame.width/2 - 48, height: image3Height))
        imageViews[2].contentMode = .scaleAspectFit
        imageViews[2].isUserInteractionEnabled = true
        imageViews[2].addGestureRecognizer(longPressGesture3)
        
        // Scroll View
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize.height = image3Y + image3Height + 70
        
        // FB Data Box
        let loginLabelY: CGFloat
        if view.frame.height > scrollView.contentSize.height {
            loginLabelY = view.frame.height - 50
        }
        else {
            loginLabelY = scrollView.contentSize.height - 50
        }
        loginLabel = UILabel(frame: CGRect(x: 0, y: loginLabelY, width: view.frame.width, height: 50))
        loginLabel.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
        loginLabel.textAlignment = NSTextAlignment.center
        loginLabel.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        loginLabel.font = UIFont.systemFont(ofSize: 10.0)
        loginLabel.text = "Logged as \(MainViewController.GlobalVariable.name)"
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(titleDescription)
        scrollView.addSubview(ingredientsLabel)
        scrollView.addSubview(ingredients)
        scrollView.addSubview(preparingLabel)
        scrollView.addSubview(preparing)
        scrollView.addSubview(imagesLabel)
        scrollView.addSubview(loginLabel)
        for view in imageViews {
            scrollView.addSubview(view)
        }
    }
    
    func setActionSheet(sender: UILongPressGestureRecognizer) {
        alertController = UIAlertController(title: "Czy chcesz zapisać obrazek?", message: nil, preferredStyle: .actionSheet)
        
        let saveImageAction = UIAlertAction(title: "Zapisz", style: .default) { (action) -> Void in
            if sender == self.longPressGesture1 {
                self.saveImage(imageview: self.imageViews[0])
            }
            else if sender == self.longPressGesture2 {
                self.saveImage(imageview: self.imageViews[1])
            }
            else if sender == self.longPressGesture3 {
                self.saveImage(imageview: self.imageViews[2])
            }
        }
        
        alertController.addAction(saveImageAction)
        
        let cancelAction = UIAlertAction(title: "Anuluj", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
    }
    
    func openActionSheet(sender: UILongPressGestureRecognizer) {
        setActionSheet(sender: sender)
        /*if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = imageview
            popoverController.sourceRect = imageview.frame
        }*/
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getImage(imageURL: String, imageView: UIImageView) {
        Alamofire.request(imageURL).responseImage { response in
            
            if let image = response.result.value {
                imageView.image = image
            }
        }
    }
    
    func saveImage(imageview: UIImageView) {
        let imageData = UIImagePNGRepresentation(imageview.image!)
        let compressedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Done!", message: "Your image has been saved", preferredStyle: .alert)
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
