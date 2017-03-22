//
//  ViewController.swift
//  0321
//
//  Created by xiaoyi li on 17/3/21.
//  Copyright © 2017年 xiaoyi li. All rights reserved.
//

import UIKit
import Photos

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height


class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    var colletionView:UICollectionView?
    var colletionViewLayout:UICollectionViewLayout?

    var assets = [PHAsset]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        colletionViewLayout = UICollectionViewFlowLayout()
        colletionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: colletionViewLayout!)
        colletionView?.delegate = self
        colletionView?.dataSource = self
        colletionView?.backgroundColor = .white
        colletionView?.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DesignViewCell")
        self.view.addSubview(colletionView!)
        


        // 获取所有相册
//        fetchAllPhoto()
        
        // 获取用户创建的相册
        fetchAllUserCreatedAlbum()
        
        DispatchQueue.main.async {
            self.colletionView?.reloadData()
        }
        
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count;
    }
    
    // 获取单元格
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // storyboard里设计的单元格
        let identify:String = "DesignViewCell"
        // 获取设计的单元格，不需要再动态添加界面元素
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identify, for: indexPath) as! CollectionViewCell
        
        //取缩略图
        let myAsset = assets[indexPath.item]
        
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
         option.isSynchronous = true
        manager.requestImage(for: myAsset, targetSize: CGSize.init(width: screenWidth/4, height: screenHeight/4), contentMode: .aspectFit, options: option) { (thumbinailImage, info) in
            print("缩略图:\(thumbinailImage),图像信息：\(info)")
            cell.imv.image = thumbinailImage
            cell.des.text = "简介"
        }
        
        
        return cell
    }
    
    // 单元格点击响应
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //这里不使用segue跳转（建议用segue跳转）
        let detailViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "detail")
            as! DetailViewController
        
        let myAsset = assets[indexPath.item]
        
        
        // navigationController跳转到detailViewController
        detailViewController.passAsset = myAsset
        self.navigationController!.pushViewController(detailViewController,
                                                      animated:true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    
    func fetchAllUserCreatedAlbum() -> Void {
        let topLevelUserCollections:PHFetchResult = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        //topLevelUserCollections中保存的是各个用户创建的相册对应的PHAssetCollection
        print("用户创建\(topLevelUserCollections.count)个")
        
        for i in 0..<topLevelUserCollections.count {
            
            //获取一个相册(PHAssetCollection)
            let collection = topLevelUserCollections[i]
            if collection.isKind(of: PHAssetCollection.classForCoder()) {
                
                //类型强制转换
                let assetCollection = collection as! PHAssetCollection
                
                
                //从每一个智能相册中获取到的PHFetchResult中包含的才是真正的资源(PHAsset)
                let assetsFetchResults:PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
                
                print("\(assetCollection.localizedTitle)相册，共有照片数:\(assetsFetchResults.count)")
                
                assetsFetchResults.enumerateObjects({ (asset, i, nil) in
                    //获取每一个资源(PHAsset)
                    print("\(asset)")
                    self.assets.append(asset)
                })
            }
        }
    }
    
    func fetchAllPhoto()  {
        let smartAlbumsFetchResult1:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        print("相册\(smartAlbumsFetchResult1.count)个")
        for i in  0..<smartAlbumsFetchResult1.count {
            // 获取一个相册
            let colletion = smartAlbumsFetchResult1[i]
            
            if colletion.isKind(of: PHAssetCollection.classForCoder()) {
                let assetColletion = colletion
                
                //取每一个相册的资源
                let assetFetchRequest = PHAsset.fetchAssets(in: assetColletion, options: nil)
                print("\(assetColletion.localizedTitle)相册,共有照片数:\(assetFetchRequest.count)")
                
                assetFetchRequest.enumerateObjects({ (asset, i, nil) in
                    // 获取每一个资源
                    print(asset)
                    self.assets.append(asset)
                })
            }
        }
    }

}




