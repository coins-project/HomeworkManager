import UIKit

class ImageViewController: ViewController {
    private var photo = Photo()
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearImage = UIImage(contentsOfFile: photo.url)
        let imageView = UIImageView(image: appearImage)
        self.view.addSubview(imageView)
    }

    func setPhoto(photo: Photo) {
        self.photo = photo
    }
}
