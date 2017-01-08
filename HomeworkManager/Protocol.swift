import Foundation

protocol ToColorPanelDelegate {
    func setSubjectNameAndColor(subjectName: String)
}

protocol ToPhotoDelegate {
    func deliverCreateAt(createAt: NSDate)
}

