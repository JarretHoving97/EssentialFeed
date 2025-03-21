//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Jarret Hoving on 30/09/2024.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
