import UIKit
import RealmSwift

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let realm = RealmModelManager.sharedManager
    static var imageName:String = ""
    
    let documents = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory,
        .UserDomainMask, true)[0]
    
    override func viewDidAppear(animated: Bool) {
        self.pickImageFromCamera()
    }

    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            print(image)
        }
        
        if info[UIImagePickerControllerOriginalImage] != nil {
            if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                if let photoData = UIImagePNGRepresentation(image) {
                    let photoRealm = Photo()
                    
                    let fileManager = NSFileManager.defaultManager()
                    let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                    let imagePath = "\(dir)/image/"
                    do {
                        try fileManager.createDirectoryAtPath(imagePath, withIntermediateDirectories: true, attributes: nil)
                    } catch let error as NSError {
                        NSLog("Unable to create directory \(error.debugDescription)")
                    }
                    
                    CameraViewController.imageName = "\(NSDate().description).png"
                    photoRealm.createdAt = NSDate()
                    photoRealm.url = imagePath + CameraViewController.imageName
                    
                    if (photoData.writeToFile(photoRealm.url, atomically: true)) {
                        let myImage = UIImageView(image: image)
                        myImage.center = CGPointMake(187.5, 333.5)
                        self.view.addSubview(myImage)
                    }
                    else {
                        print("error writing file: \(photoRealm.url)")
                    }
                    
                    realm.create(Photo.self, value: photoRealm)
                }
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
