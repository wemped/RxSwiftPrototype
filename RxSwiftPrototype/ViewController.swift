//
//  ViewController.swift
//  RxSwiftPrototype
//
//  Created by Drake Wempe on 5/31/16.
//  Copyright © 2016 Drake Wempe. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let TEST_SLOTTER_SLUG = IGN_SLOTTER_SLUG
    var playlists = [Playlist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        self.tableView.dataSource = self
        
        Slotter.getSlotterForSlug(TEST_SLOTTER_SLUG) { (slotter) -> () in
            if let playlists = slotter.playlists{
                self.playlists = playlists
                self.tableView.reloadData()
            }
        }
    }
    
    //TABLEVIEWDATASOURCE
    
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int{
        return playlists.count;
    }
    
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("playlistCell") as! TableViewCell
        cell.populate(playlists[indexPath.row])
        return cell
    }
    
    func tableView(table: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        var result = 21
        result += playlists[indexPath.row].videos.count * 24
        return CGFloat(result)
    }
}

