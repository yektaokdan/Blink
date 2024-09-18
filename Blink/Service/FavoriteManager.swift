import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    
    private var favorites: [RSSItem] = []
    
    private init() {}
    
    func addFavorite(item: RSSItem) {
        // Favorilere ekliyoruz
        favorites.append(item)
    }
    
    func getFavorites() -> [RSSItem] {
        return favorites
    }
    
    func removeFavorite(item: RSSItem) {
        if let index = favorites.firstIndex(where: { $0.link == item.link }) {
            favorites.remove(at: index)
        }
    }
}
