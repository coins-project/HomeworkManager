import UIKit

class ImageViewController: ViewController {
    var image: Photo = Photo()
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearImage = UIImage(contentsOfFile: image.url)
        let imageView = UIImageView(image: appearImage)
        self.view.addSubview(imageView)
    }
}
