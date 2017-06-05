import UIKit
import Alamofire
import AlamofireImage
import FacebookCore

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
    var pressGestures = [UILongPressGestureRecognizer]()
    @IBOutlet weak var loginBox: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue.async {
            self.getJSONData()
        }
        setUI()
    }
    
    
    // MARK: Functions
    
    // Data from website
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
                    self.pressGestures.append(UILongPressGestureRecognizer(target: self, action: #selector(self.openActionSheet(sender:))))
                }
                
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
            }
        }
    }
    
    // Number of images in Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    // Set the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        ImageFunctions().getImage(imageURL: urls[indexPath.row], imageView: cell.imageView)
        pressGestures[indexPath.row].minimumPressDuration = 1.0
        cell.addGestureRecognizer(pressGestures[indexPath.row])
        
        return cell
    }
    
    func setUI() {
        // Navigation Bar
        navigationController?.navigationBar.topItem!.title = "Pizza Recipe!"
        
        // FB Data Box
        if AccessToken.current != nil {
            loginBox.isHidden = false
            loginLabel.text = "Logged as \(GlobalVariables.LoginBox.name)"
            ImageFunctions().getImage(imageURL: GlobalVariables.LoginBox.profileImageURL, imageView: profileImage)
        }
        else {
            loginBox.isHidden = true
        }
        
        // View Height
        if view.bounds.width > 350 && view.bounds.width < 400 {
            viewHeight.constant = 1300
        }
        else if view.bounds.width >= 400 && view.bounds.width < 450 {
            viewHeight.constant = 1200
        }
        else if view.bounds.width >= 450 {
            viewHeight.constant = view.bounds.height - 64
        }
    }

    func setActionSheet(sender: UILongPressGestureRecognizer) {
        // Title
        alertController = UIAlertController(title: "Czy chcesz zapisać obrazek?", message: nil, preferredStyle: .actionSheet)
        
        // Save option
        let saveImageAction = UIAlertAction(title: "Zapisz", style: .default) { (action) -> Void in
            for index in 0 ... self.pressGestures.count - 1 {
                if sender == self.pressGestures[index] {
                    let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as! ImageCollectionViewCell
                    ImageFunctions().saveImage(imageview: cell.imageView, viewController: self)
                }
            }
        }
        alertController.addAction(saveImageAction)
        
        // Cancel option
        let cancelAction = UIAlertAction(title: "Anuluj", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
    }
    
    //
    func openActionSheet(sender: UILongPressGestureRecognizer) {
        setActionSheet(sender: sender)
        for index in 0 ... self.pressGestures.count - 1 {
            if sender == self.pressGestures[index] {
                let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as! ImageCollectionViewCell
                let popoverController = alertController.popoverPresentationController
                popoverController?.sourceView = cell
                popoverController?.sourceRect = cell.bounds
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Set again Navigation Title
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParentViewController {
            navigationController?.navigationBar.topItem!.title = "RecipeMaster"
        }
    }
}
