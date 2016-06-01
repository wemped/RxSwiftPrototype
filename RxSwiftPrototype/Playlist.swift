//
//  Playlist.swift
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

class Playlist{
    static let PLAYLIST_API_URL = IGN_PLAYLIST_API_PATH
    static let SLUG_PATH = "slug/"
    
    let id : String!
    let slug : String!
    let date : String!
    var title : String?
    
    var isMore = false
    var videos = [Video]()
    
    init(json: JSON){
        self.id = json["playlistId"].string
        
        let meta = json["metadata"]
        self.slug = meta["slug"].string
        self.date = meta["publishDate"].string
        self.title = meta["name"].string
        
        let vidsData = json["videos"]
        self.isMore = vidsData["isMore"].bool!
        
        let vids = vidsData["data"].array
        if ((vids) != nil){
            for video in vids! {
                self.videos.append(Video(json: video))
            }
        }
    }
    
    static func createObservable(slug: String) -> Observable<Playlist> {
        return Observable.create({ (observer) -> Disposable in
            let url = PLAYLIST_API_URL + SLUG_PATH + slug
            let request = Alamofire.request(.GET, url)
                .responseJSON(completionHandler: { (response) -> Void in
                    if let data = response.data {
                        observer.onNext(Playlist(json: JSON(data: data)))
                        observer.onCompleted()
                    }else if let error = response.result.error {
                        observer.onError(error)
                    }
                })
            return AnonymousDisposable{
                request.cancel()
            }
        })
    }
}