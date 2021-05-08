//
//  TopRateViewController.swift
//  TMDB
//
//  Created by 連振甫 on 2021/5/5.
//

import UIKit

class TopRateViewController: UIViewController{

    @IBOutlet weak var topRateCollectionView:UICollectionView!
    
    var model:TopRatedResponse?
    let baseImgURL = "https://image.tmdb.org/t/p/w500/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.overrideUserInterfaceStyle = .light
        // Do any additional setup after loading the view.
        
        self.topRateCollectionView.delegate = self
        self.topRateCollectionView.dataSource = self
        self.topRateCollectionView.register(UINib(nibName: "VideoCardViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCard")
        
        
        //不聽我ㄉ
        if let layout = topRateCollectionView as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: topRateCollectionView.frame.width*0.2, height: topRateCollectionView.frame.height*0.7)
        }
        
        DataManager.shared.fetchTopRated(completion: { [self] result in
            switch result {
            case .success(let topRated):
                print("topRated success:\(topRated)")
                model = topRated
                DispatchQueue.main.async {
                    topRateCollectionView.reloadData()
                }
                
            case .failure(let error):
                print("topRated failure:\(error)")

            }
        })
    }
    
}

extension TopRateViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCard", for: indexPath) as! VideoCardViewCell
        let data = model?.results[indexPath.row]
        
        
        if let imageURL = URL(string: "\(baseImgURL)\(data?.poster_path ?? "")"){
            DataManager.shared.fetchImage(url: imageURL, completionHandler: { (image,url) in
                
                DispatchQueue.main.async {
                    if imageURL == url {
                        cell.videoImageView.image = image
                    }
                }
                
            })
        }
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        cell.dateLabel.text = data?.first_air_date
        cell.titleLabel.text = data?.name
        cell.voteLabel.text = String(data?.vote_average ?? 0.0)
        cell.tag = data?.id ?? 0
        
        return cell
        
    }
    
}

extension TopRateViewController:UICollectionViewDelegateFlowLayout {
    
    /// 設定 Collection View 距離 Super View上、下、左、下間的距離
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: videoCardWidth*0.2, bottom: 0, right: videoCardWidth*0.2)
        
    }
    
    ///  設定 CollectionViewCell 的寬、高
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - indexPath: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: videoCardWidth*2, height: videoCardHeight*2)
        
    }
    
    /// 滑動方向為「垂直」的話即「上下」的間距(預設為重直)
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return videoCardWidth*0.2
        
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
