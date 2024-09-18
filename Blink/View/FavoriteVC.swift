import UIKit

class FavoriteVC: UIViewController {
    private var favoritesCollectionView: UICollectionView!
    private let vm = FavoriteVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupFavoritesCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Favori listesini her seferinde güncelle
        vm.fetchFavorites()
        favoritesCollectionView.reloadData()
    }
    
    private func setupFavoritesCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16 // Hücreler arasındaki dikey boşluk
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        favoritesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        favoritesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        favoritesCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(favoritesCollectionView)
        
        NSLayoutConstraint.activate([
            favoritesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoritesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoritesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoritesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FavoriteVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = vm.item(at: indexPath)
        cell.configure(with: item.imageUrl, title: item.title, description: item.description)
        return cell
    }
    
    // Hücrelerin tam genişlikte olması için tek sütun düzeni
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 16 // Kenarlardan boşluk
        return CGSize(width: width, height: 150) // Hücre yüksekliği sabit, genişliği ekran genişliği
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = vm.item(at: indexPath)
        if let url = URL(string: item.link) {
            UIApplication.shared.open(url)
        }
    }
}
