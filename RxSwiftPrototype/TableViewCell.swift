//
//  TableViewCell.swift
//  RxSwiftPrototype
//
//  Created by Drake Wempe on 6/2/16.
//  Copyright © 2016 Drake Wempe. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var playlistLabelView: UILabel!
    @IBOutlet weak var videoLabelView: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {}
    
    func populate (playlist: Playlist){
        playlistLabelView.text = playlist.title
        
        var lastY = videoLabelView.frame.origin.y
        let labelHeight = videoLabelView.frame.height
        for video in playlist.videos{
            var newY = lastY + labelHeight
            let videoLabel = UILabel(frame: CGRect(x: videoLabelView.frame.origin.x , y: newY, width: videoLabelView.frame.width, height: videoLabelView.frame.height))
            
            videoLabel.text = video.title
            self.addSubview(videoLabel)
            lastY = newY
        }
        
        videoLabelView.hidden = true
    }
}
