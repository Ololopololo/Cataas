import UIKit
import WACore
import SnapKit

class CatHistoryViewController: UICollectionViewController, AppParameters {
    
    private var viewModel = CatHistoryViewModel()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 2
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let itemsPerRow: CGFloat = 3
        let paddingSpace = spacing * (itemsPerRow + 1)
        let availableWidth = UIScreen.main.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        layout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationCenter()
        loadImagesArray()
//        setupActions()
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        refreshScreen()
    }
}

//MARK: - Methods
private extension CatHistoryViewController {
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .catHistoryShouldRefresh, object: nil)
    }
    
    func setupCollectionView() {
        collectionView.register(CatImageCell.self, forCellWithReuseIdentifier: "CatImageCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func loadImagesArray() {
        DispatchQueue.main.async {
            self.viewModel.loadImagesFromRealm()
        }
    }
    
    func refreshScreen() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func shouldShowCat() {
        if params.get(AppKeys.shouldShowCat, type: Bool.self).value ?? false  {
            guard let catImage = viewModel.catImages?.last?.imageData else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.present(FullScreenImageViewController(imageData: catImage), animated: true)
            }
            params.set(AppKeys.shouldShowCat, value: false)
        }
    }
//    func setupActions() {
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
//                                                                 style: .plain,
//                                                                 target: self,
//                                                                 action: #selector(openSettings))
//    }
//    @objc func openSettings() {
//        navigationController?.pushViewController(TimeSettingViewController(), animated: true)
//    }
    @objc private func refreshData() {
        refreshScreen()
        shouldShowCat()
    }
}
//MARK: - CollectionView Methods
extension CatHistoryViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.catImages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImageCell", for: indexPath) as? CatImageCell else {
            fatalError("Unable to dequeue CatImageCell")
        }
        if let catImage = viewModel.catImages?[indexPath.item] {
            cell.configure(with: catImage)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let catImage = viewModel.catImages?[indexPath.item] else {
            print("no image")
            return
        }
        let fullScreenCatVC = FullScreenImageViewController(imageData: catImage.imageData)
        present(fullScreenCatVC, animated: true)
    }
}

extension Notification.Name {
    static let catHistoryShouldRefresh = Notification.Name("catHistoryShouldRefresh")
}

