//
//  CameraViewController.swift
//  HomeworkManager
//
//  Created by 古川 和輝 on 2016/07/06.
//  Copyright © 2016年 takayuki abe. All rights reserved.
//

import UIKit
import RealmSwift

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static var realm = try! Realm()
    static var imageName:String = ""
    
    let documents = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory,
        .UserDomainMask, true)[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.pickImageFromCamera()
//        self.pickImageFromLibrary()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // 写真を撮ってそれを選択
    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    
    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
 
    
    // 写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            print(image)
        }
        
        // オリジナル写真データの取得
        if info[UIImagePickerControllerOriginalImage] != nil {
            if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                if let photoData = UIImagePNGRepresentation(image) {
                    let photoRealm = Photo()
                    
                    // 保存ディレクトリ: Documents/Photo/
                    let fileManager = NSFileManager.defaultManager()
                    let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                    let imagePath = "\(dir)/image/"
                    do {
                        try fileManager.createDirectoryAtPath(imagePath, withIntermediateDirectories: true, attributes: nil)
                    } catch let error as NSError {
                        NSLog("Unable to create directory \(error.debugDescription)")
                    }
                
                    
                    // ファイル名: 現在日時.png
                    CameraViewController.imageName = "\(NSDate().description).png"
                    photoRealm.createdAt = NSDate()
                    photoRealm.url = imagePath + CameraViewController.imageName
                    photoRealm.id = CameraViewController.lastId()
                    if (photoData.writeToFile(photoRealm.url, atomically: true)) {
                        let myImage = UIImageView(image: image) // 写真表示
                        myImage.center = CGPointMake(187.5, 333.5) // 画像の中心を設定
                        self.view.addSubview(myImage) // UIImageViewのインスタンスをビューに追加
                    }
                    else {
                        print("error writing file: \(photoRealm.url)")
                    }
                    
                    try! CameraViewController.realm.write {
                        CameraViewController.realm.add(photoRealm )
                    }
                    
                    
                                    }
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    static func lastId() -> Int {
        if let user = realm.objects(Photo).last {
            return user.id + 1
        } else {
            return 1
        }
    }
    
}
