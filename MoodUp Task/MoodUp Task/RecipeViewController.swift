import UIKit
import Alamofire
import AlamofireImage

class RecipeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: Properties
    var alertController = UIAlertController()
    let queue = DispatchQueue(label: "queue")
    
    @IBOutlet weak var appView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDescription: UITextView!
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var preparing: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    

    var urls = [String]()
/*
    var pressGestures = [UILongPressGestureRecognizer]()
    var longPressGesture1 = UILongPressGestureRecognizer()
    var longPressGesture2 = UILongPressGestureRecognizer()
    var longPressGesture3 = UILongPressGestureRecognizer()*/
    @IBOutlet weak var loginLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 /*       // Set press gestures
        pressGestures = [longPressGesture1, longPressGesture2, longPressGesture3]
        for gesture in 0...2 {
            pressGestures[gesture] = UILongPressGestureRecognizer(target: self, action: #selector(openActionSheet(sender:)))
            pressGestures[gesture].minimumPressDuration = 1.0
        }
        
*/
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
                    self.urls.append(image as! String)
                }
                
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        getImage(imageURL: urls[indexPath.row], imageView: cell.imageView)
        
        return cell
    }
    
    func setUI() {
        // Navigation Bar
        navigationController?.navigationBar.topItem!.title = "Pizza Recipe!"
/*
        // Scroll View
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize.height = image3Y + image3Height + 70
       */
        
        // FB Data Box
        loginLabel.text = "Logged as \(MainViewController.GlobalVariable.name)"
    }
/*
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
*/    
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
