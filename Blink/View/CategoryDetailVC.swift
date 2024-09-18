import UIKit

class CategoryDetailVC: UIViewController {
    private var newsCollectionView: UICollectionView!
    var categoryTitle: String?
    var rssURL: String?
    private let viewModel = CategoryDetailVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        setupNewsCollectionView()
        
        viewModel.onNewsItemsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.newsCollectionView.reloadData()
            }
        }
        
        if let rssURL = rssURL {
            viewModel.fetchRSSData(rssURL: rssURL)
        }
        
        // Uzun basma gesture recognizer ekliyoruz
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        newsCollectionView.addGestureRecognizer(longPressRecognizer)
    }
    
    private func setupNewsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        newsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        newsCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        newsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        newsCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(newsCollectionView)
        
        NSLayoutConstraint.activate([
            newsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            newsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: newsCollectionView)
        if let indexPath = newsCollectionView.indexPathForItem(at: location), gesture.state == .began {
            let item = viewModel.item(at: indexPath)
            showFavoritePopup(for: item)
        }
    }
    
    private func showFavoritePopup(for item: RSSItem) {
        let alertController = UIAlertController(title: "Favorilere Ekle", message: "Bu haberi favorilere eklemek istiyor musunuz?", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Evet", style: .default) { [weak self] _ in
            self?.addToFavorites(item: item)
        }
        let cancelAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func addToFavorites(item: RSSItem) {
        FavoriteManager.shared.addFavorite(item: item)
    }
}

extension CategoryDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = viewModel.item(at: indexPath)
        cell.configure(with: item.imageUrl, title: item.title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 32
        let collectionViewSize = collectionView.frame.size.width - padding
        let width = collectionViewSize / 2
        return CGSize(width: width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath)
        if let url = URL(string: item.link) {
            UIApplication.shared.open(url)
        }
    }
}
