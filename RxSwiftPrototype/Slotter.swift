//
//  Slotter.swift
//  RxSwiftPrototype
//
//  Created by Drake Wempe on 5/31/16.
//  Copyright © 2016 Drake Wempe. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RxCocoa
import RxSwift

class Slotter {
    static let SLOTTER_API_URL = IGN_SLOTTER_API_PATH
    static let PUBLISHED_PATH = "/_published"
    
    let id : String!
    let slug : String!
    let date : String!
    var title : String?
    var playlistSlugs = [String]()
    var playlists : [Playlist]?
    
    init(json : JSON){
        let meta = json["meta"]
        self.id = meta["id"].string
        self.slug = meta["slug"].string
        self.title = meta["name"].string
        self.date = meta["timestamp"].string
        
        let playlists = json["version", "items"].array
        var urlChunks = [String]()
        for playlist in playlists!{
            urlChunks = (playlist["url"].string?.characters.split("/").map(String.init))!
            playlistSlugs.append(urlChunks[urlChunks.count - 1])
        }
    }
    
    private static func getPlaylistObservers(slugs : [String]) -> [Observable<Playlist>]{
        var observables = [Observable<Playlist>]()
        for slug in slugs{
            observables.append(Playlist.createObservable(slug))
        }
        return observables
    }
    
    static func getSlotterForSlug(slug: String, callback : (slotter: Slotter) -> (Any)){
        let url = SLOTTER_API_URL + slug + PUBLISHED_PATH
    
        Alamofire.request(.GET, url).responseJSON { (response) in
            let json = JSON(data: response.data!)
            let slotter = Slotter(json: json)
            
            getPlaylistObservers(slotter.playlistSlugs).zip({ (playlists) -> [Playlist] in
                return playlists
            })
                .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
                .observeOn(MainScheduler.instance)
                .subscribe({ event in //not sure why this is an event but oh well
                    slotter.playlists = event.element
                    callback(slotter: slotter)
                })
            
        }
    }
}