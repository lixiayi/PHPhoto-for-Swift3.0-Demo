//
//  DetailViewController.swift
//  0321
//
//  Created by xiaoyi li on 17/3/21.
//  Copyright © 2017年 xiaoyi li. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController {
    
    var passAsset:PHAsset!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //获取原图
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions() //可以设置图像的质量、版本、也会有参数控制图像的裁剪
        option.isSynchronous = true
        
        manager.requestImage(for: passAsset, targetSize:PHImageManagerMaximumSize, contentMode: .aspectFit, options: option) { (originImage, info) in
            
            print("原图:\(originImage),图像信息：\(info)")
            DispatchQueue.main.async {
                self.imageView.image = originImage
                let infoNew : [AnyHashable : Any] = info!
                let fileUrl =  infoNew["PHImageFileURLKey"] as! URL
                self.textView.text = fileUrl.absoluteString
            }
        }

        
    
        
    }

}
