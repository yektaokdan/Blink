import Foundation

struct NewsCategory {
    let title: String
    let url: String
}

class NewsCategoriesVM {
    private(set) var categories: [NewsCategory] = []
    
    init() {
        loadCategories()
    }
    
    private func loadCategories() {
        categories = [
            NewsCategory(title: "Gündem", url: "https://www.ahaber.com.tr/rss/gundem.xml"),
            NewsCategory(title: "Ekonomi", url: "https://www.ahaber.com.tr/rss/ekonomi.xml"),
            NewsCategory(title: "Spor", url: "https://www.ahaber.com.tr/rss/spor.xml"),
            NewsCategory(title: "Yaşam", url: "https://www.ahaber.com.tr/rss/yasam.xml"),
            NewsCategory(title: "Dünya", url: "https://www.ahaber.com.tr/rss/dunya.xml"),
            NewsCategory(title: "Son 24 Saat", url: "https://www.ahaber.com.tr/rss/son24saat.xml"),
            NewsCategory(title: "Teknoloji", url: "https://www.ahaber.com.tr/rss/teknoloji.xml"),
            NewsCategory(title: "Magazin", url: "https://www.ahaber.com.tr/rss/magazin.xml"),
            NewsCategory(title: "Otomobil", url: "https://www.ahaber.com.tr/rss/otomobil.xml"),
            NewsCategory(title: "Haberler", url: "https://www.ahaber.com.tr/rss/haberler.xml"),
            NewsCategory(title: "Din", url: "https://www.ahaber.com.tr/rss/din.xml"),
            NewsCategory(title: "Tarih", url: "https://www.ahaber.com.tr/rss/tarih.xml"),
            NewsCategory(title: "Analiz", url: "https://www.ahaber.com.tr/rss/analiz.xml"),
            NewsCategory(title: "Sağlık", url: "https://www.ahaber.com.tr/rss/saglik.xml")
        ]
    }
}
