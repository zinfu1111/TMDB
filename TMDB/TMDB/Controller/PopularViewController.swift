//
//  PopularViewController.swift
//  TMDB
//
//  Created by 連振甫 on 2021/5/5.
//

import UIKit

class PopularViewController: UIViewController,ViewRouteProtocol {

    @IBOutlet weak var popularCollectionView:UICollectionView!
    
    var tvData:TVResponse?
    var movieData:MovieResponse?
    var dataType:DataType = .TV
    let baseImgURL = "https://image.tmdb.org/t/p/w500/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.overrideUserInterfaceStyle = .light
        
        self.popularCollectionView.delegate = self
        self.popularCollectionView.dataSource = self
        self.popularCollectionView.register(UINib(nibName: "VideoCardViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCard")
        
        updateDataView()
        
    }
    
    @IBAction func onChange(sender: UISegmentedControl) {
        dataType = DataType(rawValue: sender.selectedSegmentIndex) ?? .TV
        popularCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        updateDataView()
    }

    func updateDataView() {
        switch dataType {
        case .TV:
            fetchTVData()
            break
        case .Movie:
            fetchMovieData()
            break
        default:
            break
        }
    }
    
    func fetchTVData(){
        DataManager.shared.fetchTVData(type: .Popular, completion: { [self] result in
            switch result {
            case .success(let tv):
                tvData = tv
                DispatchQueue.main.async {
                    popularCollectionView.reloadData()
                }
                
            case .failure(let error):
                print("topRated failure:\(error)")

            }
        })
    }
    
    func fetchMovieData() {
        DataManager.shared.fetchMovieData(type: .Popular, completion: { [self] result in
            switch result {
            case .success(let movies):
                movieData = movies
                DispatchQueue.main.async {
                    popularCollectionView.reloadData()
                }
                
            case .failure(let error):
                print("topRated failure:\(error)")

            }
        })
    }

}


extension PopularViewController:UICollectionViewDataSource, UICollectionViewDelegate {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCard", for: indexPath) as! VideoCardViewCell
        
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        switch dataType {
        case .TV:
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
            let data = movieData?.results[indexPath.row]
            
            if let imageURL = URL(string: "\(baseImgURL)\(data?.poster_path ?? "")"){
                DataManager.shared.fetchImage(url: imageURL, completionHandler: { (image,url) in
                    
                    DispatchQueue.main.async {
                        if imageURL == url {
                            cell.videoImageView.image = image
                        }
                    }
                    
                })
            }
            
            cell.dateLabel.text = data?.release_date
            cell.titleLabel.text = data?.title
            cell.voteLabel.text = String(data?.vote_average ?? 0.0)
            cell.tag = data?.id ?? 0
            return cell
        default:
            return UICollectionViewCell()
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        guard let id = (dataType == .Movie) ? movieData?.results[indexPath.row].id.toString() : tvData?.results[indexPath.row].id.toString() else { return }
        
        switch dataType {
        case .TV:
            showTVDetail(id)
            break
        case .Movie:
            showMoiveDetail(id)
            break
        default:
            break
        }
        
    }
    
    func showTVDetail(_ id:String) {
        DataManager.shared.fetchTVDetail(id: id, completion: {[self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tv):
                    let viewModel = DetailViewModel(type: .TV, tvData: tv, movieData: nil)
                    showDetailViewController(viewModel: viewModel)
                case .failure(let error):
                    showMessageBox(title: "錯誤", msg: "\(error.localizedDescription)",action: nil)
                }
            }
        })
    }
    
    func showMoiveDetail(_ id:String) {
        DataManager.shared.fetchMovieDetail(id: id, completion: {[self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movie):
                    let viewModel = DetailViewModel(type: .Movie, tvData: nil, movieData: movie)
                    showDetailViewController(viewModel: viewModel)
                case .failure(let error):
                    showMessageBox(title: "錯誤", msg: "\(error.localizedDescription)",action: nil)
                }
            }
        })
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
