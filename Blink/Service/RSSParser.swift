//
//  RSSParser.swift
//  Blink
//
//  Created by trc vpn on 26.06.2024.
//

import Foundation

class RSSParser: NSObject, XMLParserDelegate {
    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    private var currentTitle = ""
    private var currentLink = ""
    private var currentDescription = ""
    private var currentPubDate = ""
    private var currentImageUrl = ""

    private var completion: (([RSSItem]) -> Void)?
    
    func parseRSS(data: Data, completion: @escaping ([RSSItem]) -> Void) {
        self.completion = completion
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if currentElement == "item" {
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
            currentPubDate = ""
            currentImageUrl = ""
        }
        
        if elementName == "media:thumbnail" || elementName == "media:content" || elementName == "enclosure" {
            if let url = attributeDict["url"] {
                currentImageUrl = url
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "link":
            currentLink += string
        case "description":
            currentDescription += string
        case "pubDate":
            currentPubDate += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                                  link: currentLink.trimmingCharacters(in: .whitespacesAndNewlines),
                                  description: currentDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                                  pubDate: currentPubDate.trimmingCharacters(in: .whitespacesAndNewlines),
                                  imageUrl: currentImageUrl.trimmingCharacters(in: .whitespacesAndNewlines))
            rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completion?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Error parsing XML: \(parseError.localizedDescription)")
    }
}
