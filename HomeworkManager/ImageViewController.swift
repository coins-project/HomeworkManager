import UIKit

class ImageViewController: ViewController {
    private var photo = Photo()
    private var backButton = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearImage = UIImage(contentsOfFile: photo.url)
        let imageView = UIImageView(image: appearImage)
        self.view.addSubview(imageView)
        backButton = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "backButtonDidTap")
        self.navigationItem.rightBarButtonItem = backButton
        
    }

    func setPhoto(photo: Photo) {
        self.photo = photo
    }
    
    func backButtonDidTap() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
