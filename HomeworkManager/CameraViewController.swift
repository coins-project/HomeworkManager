import UIKit
import RealmSwift

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let realm = RealmModelManager.sharedManager
    static var imageName:String = ""
    
    let documents = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory,
        .UserDomainMask, true)[0]
    
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
        }
        
        if info[UIImagePickerControllerOriginalImage] != nil {
            if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                if let photoData = UIImagePNGRepresentation(image) {
                    let photoRealm = Photo()
                    
                    let fileManager = NSFileManager.defaultManager()
                    let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                    let imagePath = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("images")
                    
                    do {
                        try fileManager.createDirectoryAtPath(imagePath.path!, withIntermediateDirectories: true, attributes: nil)
                    } catch let error as NSError {
                        NSLog("Unable to create directory \(error.debugDescription)")
                    }
                    
                    CameraViewController.imageName = "\(TimezoneConverter.convertToJST(NSDate()).description).png"
                    
                    photoRealm.createdAt = TimezoneConverter.convertToJST(NSDate())
                    photoRealm.url = imagePath.URLByAppendingPathComponent(CameraViewController.imageName).path!
                    
                    if(photoData.writeToFile(photoRealm.url, atomically: true)){
                        realm.create(Photo.self, value: photoRealm) 
                        print("realm url = \(photoRealm.url)")
                    } else {
                        print("error writing file: \(photoRealm.url)")
                    }                }
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
