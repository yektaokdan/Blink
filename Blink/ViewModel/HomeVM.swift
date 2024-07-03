import Foundation

class HomeVM {
    let rssService = RSSService()
    let rssParser = RSSParser()
    private var newsItems: [RSSItem] = [] {
        didSet {
            self.onNewsItemsUpdated?()
        }
    }
    var onNewsItemsUpdated: (() -> Void)?
    
    func fetchRSSData() {
        guard let url = URL(string: "https://www.ahaber.com.tr/rss/gundem.xml") else { return }
        
        // Mevcut haberleri temizle
        newsItems = []
        self.onNewsItemsUpdated?()
        
        // Yeni verileri çek ve ekle
        rssService.fetchRSSFeed(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.rssParser.parseRSS(data: data) { newsItems in
                    DispatchQueue.main.async {
                        self?.newsItems = newsItems
                    }
                }
            case .failure(let error):
                print("RSS beslemesi alınamadı: \(error.localizedDescription)")
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
