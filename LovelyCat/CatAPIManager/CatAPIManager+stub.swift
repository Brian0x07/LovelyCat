//
//  CatAPIManager+stub.swift
//  LovelyCat
//
//  Created by xiaolei on 1/12/26.
//

import Foundation

extension CatAPIManager.Endpoint {
    var stub: Data {
        let str: String
        switch self {
        case .images:
            str = """
        [
            {
                "id": "a18",
                "url": "https://cdn2.thecatapi.com/images/a18.png",
                "width": 441,
                "height": 552
            },
            {
                "id": "a3e",
                "url": "https://cdn2.thecatapi.com/images/a3e.jpg",
                "width": 960,
                "height": 1280
            },
            {
                "id": "abq",
                "url": "https://cdn2.thecatapi.com/images/abq.gif",
                "width": 500,
                "height": 375
            },
            {
                "id": "bof",
                "url": "https://cdn2.thecatapi.com/images/bof.jpg",
                "width": 500,
                "height": 333
            },
            {
                "id": "cm7",
                "url": "https://cdn2.thecatapi.com/images/cm7.jpg",
                "width": 383,
                "height": 500
            },
            {
                "id": "d19",
                "url": "https://cdn2.thecatapi.com/images/d19.jpg",
                "width": 620,
                "height": 720
            },
            {
                "id": "dk0",
                "url": "https://cdn2.thecatapi.com/images/dk0.jpg",
                "width": 500,
                "height": 333
            },
            {
                "id": "ef8",
                "url": "https://cdn2.thecatapi.com/images/ef8.jpg",
                "width": 500,
                "height": 334
            },
            {
                "id": "gCEFbK7in",
                "url": "https://cdn2.thecatapi.com/images/gCEFbK7in.jpg",
                "width": 1424,
                "height": 987
            },
            {
                "id": "yKXeUMNZ8",
                "url": "https://cdn2.thecatapi.com/images/yKXeUMNZ8.jpg",
                "width": 1080,
                "height": 1350
            }
        ]
        """
        case .addToFavorite:
            str = """
        {
            "id":100038507
        }
        """
        case .favorites:
            str = """
        [{
        "id":100038507,
        "image_id":"E8dL1Pqpz",
        "sub_id":null,
        "created_at":"2022-07-10T12:24:39.000Z",
        "image":{
            "id":"E8dL1Pqpz",
            "url":"https://cdn2.thecatapi.com/images/E8dL1Pqpz.jpg" 
            }
        }]
        """
        case .removeFromFavorite(id: let id):
            str = ""
        }
        
        return Data(str.utf8)
    }
}
