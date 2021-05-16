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

class DetailViewController: UIViewController {

    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.isHidden = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height * 0.5
        rateButton.layer.cornerRadius = rateButton.frame.height * 0.5
        playButton.layer.cornerRadius = playButton.frame.height * 0.5
        self.view.isHidden = false
    }
    
    @IBAction func closeViewController(){
        self.dismiss(animated: true, completion: nil)
    }

}
