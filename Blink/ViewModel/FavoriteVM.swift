import Foundation

class FavoriteVM {
    private var favorites: [RSSItem] = [] {
        didSet {
            onFavoritesUpdated?()
        }
    }
    
    var onFavoritesUpdated: (() -> Void)?
    
    func fetchFavorites() {
        // Favoriler listesini çekiyoruz
        favorites = FavoriteManager.shared.getFavorites()
    }
    
    func numberOfItems() -> Int {
        return favorites.count
    }
    
    func item(at indexPath: IndexPath) -> RSSItem {
        return favorites[indexPath.row]
    }
}
