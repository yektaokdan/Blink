import UIKit
import CHTCollectionViewWaterfallLayout

class HomeVC: UIViewController {
    private var newsCollectionView: UICollectionView!
    private var categoryCollectionView: UICollectionView!
    let vm = HomeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryCollectionView()
        setupNewsCollectionView()
        
        vm.onNewsItemsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.categoryCollectionView.reloadData()
                self?.newsCollectionView.reloadData()
            }
        }
        vm.fetchRSSData()
    }
    
    private func setupCategoryCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(categoryCollectionView)
        
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupNewsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8) // Kenar boşluklarını ayarlar
        
        newsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        newsCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        newsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        newsCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(newsCollectionView)
        
        NSLayoutConstraint.activate([
            newsCollectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 16),
            newsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return vm.newsCategories.count
        } else {
            return vm.numberOfItems()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            let category = vm.newsCategories[indexPath.row]
            let isActive = category == vm.activeCategory
            cell.configure(with: category, isActive: isActive)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
                return UICollectionViewCell()
            }
            let item = vm.item(at: indexPath)
            cell.configure(with: item.imageUrl, title: item.title)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let selectedCategory = vm.newsCategories[indexPath.row]
            vm.activeCategory = selectedCategory
            categoryCollectionView.reloadData()
            newsCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize(width: 100, height: 50)
        } else {
            let padding: CGFloat = 32
            let collectionViewSize = collectionView.frame.size.width - padding
            let width = collectionViewSize / 2
            return CGSize(width: width, height: 150)
        }
    }
}
