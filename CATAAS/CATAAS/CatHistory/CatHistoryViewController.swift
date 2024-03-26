import UIKit
import SnapKit

class CatHistoryViewController: UICollectionViewController {
    
    private var viewModel = CatHistoryViewModel()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 2
        layout.minimumInteritemSpacing = spacing // items in the same row
        layout.minimumLineSpacing = spacing // between rows
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing) // from the section borders
        
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
        loadImagesArray()
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        refreshScreen()
    }
}

//MARK: - Methods
private extension CatHistoryViewController {
    func setupCollectionView() {
        collectionView.register(CatImageCell.self, forCellWithReuseIdentifier: "CatImageCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func loadImagesArray() {
        viewModel.loadImagesFromRealm()
    }
    
    func refreshScreen() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
}
