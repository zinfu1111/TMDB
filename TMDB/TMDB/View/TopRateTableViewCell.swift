//
//  TopRateTableViewCell.swift
//  TMDB
//
//  Created by 連振甫 on 2021/5/11.
//

import UIKit

class TopRateTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    var tvData:TVResponse?
    var movieData:MovieResponse?
    var dataType:DataType = .TV
    let baseImgURL = "https://image.tmdb.org/t/p/w500/"
    var currentIndex = 0
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let layout = collectionView as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        self.collectionView.register(UINib(nibName: "BannerViewCell", bundle: nil), forCellWithReuseIdentifier: "Banner")
        self.collectionView.register(UINib(nibName: "VideoCardViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCard")
        
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if dataType == .TV {
            setTVStyle()
        }
        else
        {
            setMovieStyle()
        }
        
    }
    
    func setTVStyle() {
        //設定scroll樣式
        collectionView.isPagingEnabled = false
        //抓取電視資料
        fetchTVData()
    }
    
    func setMovieStyle() {
        //設定scroll樣式
        self.collectionView.layer.cornerRadius = self.collectionView.frame.height * 0.05
        collectionView.isPagingEnabled = true
        //抓取資料
        fetchMovieData()
        //設定Banner輪播
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(loopBanner), userInfo: nil, repeats: true)
    }
    
    
    @objc func loopBanner(){
        if dataType == .TV {
            
            guard let tvCount = self.tvData?.results.count, tvCount != 0 else { return }
            
            DispatchQueue.main.async {
                
                var indexPath: IndexPath
                self.currentIndex += 1
                
                if self.currentIndex < tvCount {
                    indexPath = IndexPath(item: self.currentIndex, section: 0)
                    self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                }else{
                    self.currentIndex = 0
                    indexPath = IndexPath(item: self.currentIndex, section: 0)
                    self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                    
                }
            }
        }else{
            guard let movieCount = self.movieData?.results.count, movieCount != 0 else { return }
            
            DispatchQueue.main.async {
                
                var indexPath: IndexPath
                self.currentIndex += 1
                
                if self.currentIndex < movieCount {
                    indexPath = IndexPath(item: self.currentIndex, section: 0)
                    self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                }else{
                    self.currentIndex = 0
                    indexPath = IndexPath(item: self.currentIndex, section: 0)
                    self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                    
                }
            }
        }
    }
    
    func fetchTVData(){
        DataManager.shared.fetchTVData(type: .TopRate, completion: { [self] result in
            switch result {
            case .success(let tv):
                tvData = tv
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
                
            case .failure(let error):
                print("topRated failure:\(error)")

            }
        })
    }
    
    func fetchMovieData() {
        DataManager.shared.fetchMovieData(type: .TopRate, completion: { [self] result in
            switch result {
            case .success(let movies):
                movieData = movies
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
                
            case .failure(let error):
                print("topRated failure:\(error)")

            }
        })
    }

}

extension TopRateTableViewCell:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch dataType {
        case .TV:
            return tvData?.results.count ?? 0
        case .Movie:
            return movieData?.results.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch dataType {
        case .TV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCard", for: indexPath) as! VideoCardViewCell
            
            
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowOffset = CGSize(width: 0, height: 10)
            
            let data = tvData?.results[indexPath.row]
            
            if let imageURL = URL(string: "\(baseImgURL)\(data?.poster_path ?? "")"){
                DataManager.shared.fetchImage(url: imageURL, completionHandler: { (image,url) in
                    
                    DispatchQueue.main.async {
                        if imageURL == url {
                            cell.videoImageView.image = image
                        }
                    }
                    
                })
            }
            
            cell.dateLabel.text = data?.first_air_date
            cell.titleLabel.text = data?.name
            cell.voteLabel.text = String(data?.vote_average ?? 0.0)
            cell.tag = data?.id ?? 0
            
            return cell
        case .Movie:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Banner", for: indexPath) as! BannerViewCell
            
            cell.backgroundColor = .black
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowOffset = CGSize(width: 0, height: 10)
            
            let data = movieData?.results[indexPath.row]
            
            if let imageURL = URL(string: "\(baseImgURL)\(data?.backdrop_path ?? "")"){
                DataManager.shared.fetchImage(url: imageURL, completionHandler: { (image,url) in
                    
                    DispatchQueue.main.async {
                        if imageURL == url {
                            cell.imageView.image = image
                        }
                    }
                    
                })
            }
            
            cell.titleLabel.text = data?.title
            cell.tag = data?.id ?? 0
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
}

extension TopRateTableViewCell:UICollectionViewDelegateFlowLayout {
    
    /// 設定 Collection View 距離 Super View上、下、左、下間的距離
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    ///  設定 CollectionViewCell 的寬、高
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - indexPath: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (dataType == .TV) ? videoCardWidth : collectionView.frame.width
        let height = (dataType == .TV) ? collectionView.frame.height*0.9 : collectionView.frame.height
        
        
        return CGSize(width: width, height: height)
        
    }
    
    /// 滑動方向為「垂直」的話即「上下」的間距(預設為重直)
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return (dataType == .TV) ? videoCardWidth*0.1 : 0
        
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
