//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Jarret Hoving on 18/03/2024.
//

import Foundation

 struct RemoteFeedItem: Decodable {
     let id: UUID
     let description: String?
     let location: String?
     let image: URL
}
