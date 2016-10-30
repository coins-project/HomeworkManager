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
        if let _ = info[UIImagePickerControllerOriginalImage] {
            if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
                UIGraphicsBeginImageContext(size)
                image.drawInRect(CGRectMake(0, 0, size.width, size.height))
                let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                if let photoData = UIImagePNGRepresentation(resizeImage!) {
                    let photoRealm = Photo()
                    
                    let fileManager = NSFileManager.defaultManager()
                    let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                    let imagePath = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("images")
                    
                    do {
                        try fileManager.createDirectoryAtPath(imagePath!.path!, withIntermediateDirectories: true, attributes: nil)
                    } catch let error as NSError {
                        NSLog("Unable to create directory \(error.debugDescription)")
                    }
                    
                    CameraViewController.imageName = "\(TimezoneConverter.convertToJST(NSDate()).description).png"
                    
                    photoRealm.createdAt = TimezoneConverter.convertToJST(NSDate())
                    photoRealm.url = imagePath!.URLByAppendingPathComponent(CameraViewController.imageName)!.path!
                    
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
