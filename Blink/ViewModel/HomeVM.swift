import Foundation

class HomeVM {
    let rssService = RSSService()
    let rssParser = RSSParser()
    private var newsItems: [RSSItem] = [] {
        didSet {
            self.onNewsItemsUpdated?()
        }
    }
    var newsCategories: [String] = ["Akış", "Spor", "Teknoloji", "Sağlık", "Eğlence", "İş Dünyası"]
    var activeCategory: String = "Akış" {
        didSet {
            self.onNewsItemsUpdated?()
        }
    }
    
    var onNewsItemsUpdated: (() -> Void)?
    
    func fetchRSSData() {
        guard let url = URL(string: "https://www.ahaber.com.tr/rss/ekonomi.xml") else { return }
        
        rssService.fetchRSSFeed(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.rssParser.parseRSS(data: data) { newsItems in
                    self?.newsItems = newsItems
                }
            case .failure(let error):
                print("Failed to fetch RSS feed: \(error.localizedDescription)")
            }
        }
    }
    
    func numberOfItems() -> Int {
        return newsItems.count
    }
    
    func item(at indexPath: IndexPath) -> RSSItem {
        return newsItems[indexPath.row]
    }
}
