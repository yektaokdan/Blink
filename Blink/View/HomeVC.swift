import UIKit

class HomeVC: UIViewController {
    private var newsCollectionView: UICollectionView!
    private var customSearchBar: CustomSearchBar!
    let vm = HomeVM()
    
    // Search bar'ın height constraint'ini kontrol etmek için bir değişken
    private var searchBarHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomSearchBar()
        setupNewsCollectionView()
        
        vm.onNewsItemsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.newsCollectionView.reloadData()
            }
        }
        vm.fetchRSSData()
    }
    
    private func setupCustomSearchBar() {
        customSearchBar = CustomSearchBar()
        customSearchBar.onSearchTextChanged = { [weak self] searchText in
            self?.vm.filterNews(with: searchText)
        }
        
        customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customSearchBar)
        
        // height constraint'i daha sonra ayarlamak için saklıyoruz
        searchBarHeightConstraint = customSearchBar.heightAnchor.constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            customSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarHeightConstraint // height constraint'i ekledik
        ])
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
            newsCollectionView.topAnchor.constraint(equalTo: customSearchBar.bottomAnchor, constant: 16),
            newsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Uzun basma gesture recognizer ekliyoruz
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        newsCollectionView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: newsCollectionView)
        if let indexPath = newsCollectionView.indexPathForItem(at: location), gesture.state == .began {
            let item = vm.item(at: indexPath)
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

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = vm.item(at: indexPath)
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
        let item = vm.item(at: indexPath)
        if let url = URL(string: item.link) {
            UIApplication.shared.open(url)
        }
    }
    
    // Scroll hareketiyle search bar'ı küçültme veya büyütme
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        // Kaydırma miktarıyla orantılı olarak search bar'ın yüksekliğini ayarlıyoruz
        let newHeight = max(0, 50 - offsetY)
        searchBarHeightConstraint.constant = newHeight
        
        // Layout'u güncelliyoruz
        view.layoutIfNeeded()
    }
}
