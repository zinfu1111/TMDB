//
//  VideoCardViewCell.swift
//  TMDB
//
//  Created by 連振甫 on 2021/5/3.
//

import UIKit

class VideoCardViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var videoImageView:UIImageView!
    @IBOutlet weak var voteLabel:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoImageView.image = nil
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        voteLabel.layer.cornerRadius = voteLabel.bounds.midX
        
    }

}
