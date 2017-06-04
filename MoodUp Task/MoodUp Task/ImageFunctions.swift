import UIKit
import Alamofire
import AlamofireImage

class ImageFunctions {
    // Get Image from URL
    func getImage(imageURL: String, imageView: UIImageView) {
        Alamofire.request(imageURL).responseImage { response in
            
            if let image = response.result.value {
                imageView.image = image
            }
        }
    }
    
    // Save Image in Camera Roll
    func saveImage(imageview: UIImageView, viewController: UIViewController) {
        let imageData = UIImagePNGRepresentation(imageview.image!)
        let compressedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Done!", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
