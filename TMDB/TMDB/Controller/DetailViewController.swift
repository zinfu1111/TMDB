//
//  DetailViewController.swift
//  TMDB
//
//  Created by 連振甫 on 2021/5/16.
//

import UIKit

struct DetailViewModel {
    var type:DataType!
    var tvData:TVModel?
    var movieData:MovieModel?
}

class DetailViewController: UIViewController,ViewRouteProtocol {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var releaseNoteLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var viewModel:DetailViewModel!
    let baseImgURL = "https://image.tmdb.org/t/p/w500/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.isHidden = true
        
        setDataInView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        drawCircle()
        addBlurInHeaderView()
        self.view.isHidden = false
    }
    
    func setDataInView() {
        switch viewModel.type {
        case .Movie:
            guard let model = viewModel.movieData else {
                showMessageBox(title: "錯誤", msg: "查無資料", action: closeViewController())
                return
            }
            setBackdrop(path: model.backdrop_path ?? "")
            setImageView(path: model.poster_path ?? "")
            titleLabel.text = model.title
            overviewTextView.text = model.overview
            
            let genresData = genresAllName(genres: model.genres)
            releaseNoteLabel.text = "\(model.release_date)|\(genresData.joined(separator:","))"
            break
        case .TV:
            guard let model = viewModel.tvData else {
                showMessageBox(title: "錯誤", msg: "查無資料", action: closeViewController())
                return
            }
            setBackdrop(path: model.backdrop_path ?? "")
            setImageView(path: model.poster_path ?? "")
            titleLabel.text = model.name
            overviewTextView.text = model.overview
            
            let genresData = genresAllName(genres: model.genres)
            releaseNoteLabel.text = "\(model.first_air_date)|\(genresData.joined(separator:","))"
            break
        default:
            break
        }
    }
    
    func setBackdrop(path:String) {
        if let imageURL = URL(string: "\(baseImgURL)\(path)"){
            DataManager.shared.fetchImage(url: imageURL, completionHandler: { (image,url) in
                
                DispatchQueue.main.async {[self] in
                    guard let image = image else { return }
                    headerView.backgroundColor = UIColor(patternImage: image)
                }
                
            })
        }
    }
    
    func setImageView(path:String) {
        if let imageURL = URL(string: "\(baseImgURL)\(path)"){
            DataManager.shared.fetchImage(url: imageURL, completionHandler: { (image,url) in
                
                DispatchQueue.main.async {[self] in
                    imageView.image = image
                }
                
            })
        }
    }
    
    func addBlurInHeaderView() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = headerView.bounds
        headerView.addSubview(blurEffectView)
        headerView.bringSubviewToFront(imageView)
    }
    
    func drawCircle() {
        voteLabel.layer.cornerRadius = voteLabel.frame.height * 0.5
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height * 0.5
        rateButton.layer.cornerRadius = rateButton.frame.height * 0.5
        playButton.layer.cornerRadius = playButton.frame.height * 0.5
    }
    
    func genresAllName(genres:[Genres]?) -> [String] {
        
        var genresData = [String]()
        
        if let genres = genres {
            genres.forEach({ item in
                genresData.append(item.name)
            })
            
        }
        return genresData
    }
    
    @IBAction func closeViewController(){
        self.dismiss(animated: true, completion: nil)
    }

}
