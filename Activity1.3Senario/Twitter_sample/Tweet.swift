//
//  Tweet.swift
//  Twitter_sample
//
//  Created by pk on 2025-01-14.
//
import Foundation
struct Tweet: Identifiable, Decodable
{
    let id: String
    let text: String
    let likes: Int
    let dislikes: Int
    let image: String
    //https://mocki.io/v1/8893401f-a22d-4623-860f-0f993e6d6069
}
