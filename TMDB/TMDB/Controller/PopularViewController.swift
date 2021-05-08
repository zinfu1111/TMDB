//
//  PopularViewController.swift
//  TMDB
//
//  Created by 連振甫 on 2021/5/5.
//

import UIKit

class PopularViewController: UIViewController {

    @IBOutlet weak var popularCollectionView:UICollectionView!
    
    var model:PopularResponse?
    let baseImgURL = "https://image.tmdb.org/t/p/w500/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.overrideUserInterfaceStyle = .light
        
        self.popularCollectionView.delegate = self
        self.popularCollectionView.dataSource = self
        self.popularCollectionView.register(UINib(nibName: "VideoCardViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCard")
        
        
        DataManager.shared.fetchPopular(completion: { [self] result in
            switch result {
            case .success(let popular):
                print("popular success:\(popular)")
                model = popular
                DispatchQueue.main.async {
                    popularCollectionView.reloadData()
                }
            case .failure(let error):
                print("popular failure:\(error)")

            }
        })
    }
    

}


extension PopularViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCard", for: indexPath) as! VideoCardViewCell
        let data = model?.results[indexPath.row]
        
        
        if let imageURL = URL(string: "\(baseImgURL)\(data?.poster_path ?? "")"){
            DataManager.shared.fetchImage(url: imageURL, completionHandler: { (image) in
                
                DispatchQueue.main.async {
                    cell.videoImageView.image = image
                    
                }
                
            })
        }
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        cell.dateLabel.text = data?.release_date
        cell.titleLabel.text = data?.title
        cell.voteLabel.text = String(data?.vote_average ?? 0.0)
        cell.tag = data?.id ?? 0
        
        return cell
        
    }
    
}

extension PopularViewController:UICollectionViewDelegateFlowLayout {
    
    /// 設定 Collection View 距離 Super View上、下、左、下間的距離
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
    }
    
    ///  設定 CollectionViewCell 的寬、高
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - indexPath: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: videoCardWidth, height: videoCardHeight)
        
    }
    
    /// 滑動方向為「垂直」的話即「上下」的間距(預設為重直)
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
        
    }
    
    /// 滑動方向為「垂直」的話即「左右」的間距(預設為重直)
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
