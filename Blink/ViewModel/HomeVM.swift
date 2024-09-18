import Foundation

class HomeVM {
    let rssService = RSSService()
    let rssParser = RSSParser()
    private var newsItems: [RSSItem] = [] {
        didSet {
            filteredNewsItems = newsItems
        }
    }
    private(set) var filteredNewsItems: [RSSItem] = [] {
        didSet {
            self.onNewsItemsUpdated?()
        }
    }
    var onNewsItemsUpdated: (() -> Void)?
    
    func fetchRSSData() {
        guard let url = URL(string: "https://www.ahaber.com.tr/rss/anasayfa.xml") else { return }
        newsItems = []
        self.onNewsItemsUpdated?()
        
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
        return filteredNewsItems.count
    }
    
    func item(at indexPath: IndexPath) -> RSSItem {
        return filteredNewsItems[indexPath.row]
    }
    
    func filterNews(with query: String) {
        if query.isEmpty {
            filteredNewsItems = newsItems
        } else {
            filteredNewsItems = newsItems.filter { $0.title.lowercased().contains(query.lowercased()) }
        }
    }
}
