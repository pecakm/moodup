import UIKit
import Alamofire
import AlamofireImage

class RecipeViewController: UIViewController {

    // MARK: Properties
    var alertController = UIAlertController()
    let queue = DispatchQueue(label: "queue")
    var scrollView = UIScrollView()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDescription: UITextView!
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var preparing: UITextView!
    

    var imageViews = [UIImageView]()
    var image1 = UIImageView()
    var image2 = UIImageView()
    var image3 = UIImageView()
    var pressGestures = [UILongPressGestureRecognizer]()
    var longPressGesture1 = UILongPressGestureRecognizer()
    var longPressGesture2 = UILongPressGestureRecognizer()
    var longPressGesture3 = UILongPressGestureRecognizer()
    @IBOutlet weak var loginLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set press gestures
        pressGestures = [longPressGesture1, longPressGesture2, longPressGesture3]
        for gesture in 0...2 {
            pressGestures[gesture] = UILongPressGestureRecognizer(target: self, action: #selector(openActionSheet(sender:)))
            pressGestures[gesture].minimumPressDuration = 1.0
        }
        
        // Set array of images
        imageViews = [image1, image2, image3]

        queue.async {
            self.getJSONData()
        }
        setUI()
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
                i = 0
                for image in ((JSON as! NSDictionary)["imgs"] as! NSArray) {
                    self.getImage(imageURL: image as! String, imageView: self.imageViews[i])
                    i += 1
                }
            }
        }
    }
    
    func setUI() {
        // Navigation Bar
        navigationController?.navigationBar.topItem!.title = "Pizza Recipe!"
        
        /*
        // Image1
        let image1Y: CGFloat = imagesLabelY + imagesLabelHeight
        let image1Height: CGFloat = (view.frame.width/2 - 48) * 0.8
        imageViews[0] = UIImageView(frame: CGRect(x: 32, y: image1Y, width: view.frame.width/2 - 48, height: image1Height))
        imageViews[0].contentMode = .scaleAspectFit
        imageViews[0].isUserInteractionEnabled = true
        imageViews[0].addGestureRecognizer(pressGestures[0])
        
        // Image2
        imageViews[1] = UIImageView(frame: CGRect(x: view.frame.width/2 + 16, y: image1Y, width: view.frame.width/2 - 48, height: image1Height))
        imageViews[1].contentMode = .scaleAspectFit
        imageViews[1].isUserInteractionEnabled = true
        imageViews[1].addGestureRecognizer(pressGestures[1])
        
        // Image3
        let image3Y: CGFloat = image1Y + image1Height
        let image3Height: CGFloat = (view.frame.width/2 - 48) * 0.8
        imageViews[2] = UIImageView(frame: CGRect(x: 32, y: image3Y, width: view.frame.width/2 - 48, height: image3Height))
        imageViews[2].contentMode = .scaleAspectFit
        imageViews[2].isUserInteractionEnabled = true
        imageViews[2].addGestureRecognizer(pressGestures[2])

        // Scroll View
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize.height = image3Y + image3Height + 70
       */
        // FB Data Box
        loginLabel.text = "Logged as \(MainViewController.GlobalVariable.name)"
    }

    func setActionSheet(sender: UILongPressGestureRecognizer) {
        alertController = UIAlertController(title: "Czy chcesz zapisać obrazek?", message: nil, preferredStyle: .actionSheet)
        
        let saveImageAction = UIAlertAction(title: "Zapisz", style: .default) { (action) -> Void in
            if sender == self.pressGestures[0] {
                self.saveImage(imageview: self.imageViews[0])
            }
            else if sender == self.pressGestures[1] {
                self.saveImage(imageview: self.imageViews[1])
            }
            else if sender == self.pressGestures[2] {
                self.saveImage(imageview: self.imageViews[2])
            }
        }
        
        alertController.addAction(saveImageAction)
        
        let cancelAction = UIAlertAction(title: "Anuluj", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
    }
    
    func openActionSheet(sender: UILongPressGestureRecognizer) {
        setActionSheet(sender: sender)
        if sender == self.pressGestures[0] {
            let popoverController = alertController.popoverPresentationController
            popoverController?.sourceView = self.imageViews[0]
            popoverController?.sourceRect = self.imageViews[0].bounds
        }
        else if sender == self.pressGestures[1] {
            let popoverController = alertController.popoverPresentationController
            popoverController?.sourceView = self.imageViews[1]
            popoverController?.sourceRect = self.imageViews[1].bounds
        }
        else if sender == self.pressGestures[2] {
            let popoverController = alertController.popoverPresentationController
            popoverController?.sourceView = self.imageViews[2]
            popoverController?.sourceRect = self.imageViews[2].bounds
        }

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
