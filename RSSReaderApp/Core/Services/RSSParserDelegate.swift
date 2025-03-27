//
//  RSSParserDelegate.swift
//  RSSReaderApp
//
//  Created by Dominik Maric on 27.03.2025..
//

import Foundation
import SwiftUI

class RSSParserDelegate: NSObject, XMLParserDelegate {
    var currentFeed: Feed?
    private let url: URL
    
    private var currentElement = ""
    private var currentTitle = ""
    private var currentDescription = ""
    private var currentLink: URL?
    private var currentPubDate: Date?
    private var currentImageUrl: URL?
    
    private var feedTitle = ""
    private var feedDescription = ""
    private var feedImageUrl: URL?
    
    private var items: [FeedItem] = []
    
    private var inItem = false
    private var inImage = false
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        return formatter
    }()
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "item" {
            inItem = true
            currentTitle = ""
            currentDescription = ""
            currentLink = nil
            currentPubDate = nil
            currentImageUrl = nil
        }
        
        if elementName == "image" {
            inImage = true
        }
        
        if elementName == "enclosure", let urlString = attributeDict["url"], let url = URL(string: urlString) {
            if inItem {
                currentImageUrl = url
            } else if inImage {
                feedImageUrl = url
            }
        }
        
        if elementName == "media:content" || elementName == "content", let urlString = attributeDict["url"], let url = URL(string: urlString) {
            if inItem {
                currentImageUrl = url
            } else {
                feedImageUrl = url
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if data.isEmpty {
            return
        }
        
        switch currentElement {
        case "title":
            if inItem {
                currentTitle += data
            } else {
                feedTitle += data
            }
        case "description", "content:encoded":
            if inItem {
                currentDescription += data
            } else {
                feedDescription += data
            }
        case "link":
            if inItem, let url = URL(string: data) {
                currentLink = url
            }
        case "pubDate":
            if inItem, let date = dateFormatter.date(from: data) {
                currentPubDate = date
            }
        case "url":
            if inImage, let url = URL(string: data) {
                feedImageUrl = url
            }
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let item = FeedItem(
                title: currentTitle,
                description: currentDescription,
                pubDate: currentPubDate,
                link: currentLink,
                imageUrl: currentImageUrl
            )
            items.append(item)
            inItem = false
        }
        
        if elementName == "image" {
            inImage = false
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        currentFeed = Feed(
            url: url,
            title: feedTitle.isEmpty ? url.absoluteString : feedTitle,
            description: feedDescription,
            imageUrl: feedImageUrl,
            items: items
        )
    }
}
