import UIKit
import SnapKit

class CatHistoryViewController: UICollectionViewController {
    
    private var viewModel = CatHistoryViewModel()
    
    init() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            // Assuming you want the same spacing between cells and from the screen borders
            let spacing: CGFloat = 2 // You can change this value to whatever you like
            layout.minimumInteritemSpacing = spacing // Space between items in the same row
            layout.minimumLineSpacing = spacing // Space between rows
            layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing) // Insets from the section borders

            // Adjust the itemSize based on the screen width and desired spacing
            let itemsPerRow: CGFloat = 3 // Change this to change the number of items per row
            let paddingSpace = spacing * (itemsPerRow + 1)
            let availableWidth = UIScreen.main.bounds.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow

            layout.itemSize = CGSize(width: widthPerItem, height: widthPerItem) // Keep it square or adjust as needed
            super.init(collectionViewLayout: layout)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadImagesArray()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshScreen()
    }
    
    private func setupCollectionView() {
        collectionView.register(CatImageCell.self, forCellWithReuseIdentifier: "CatImageCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func loadImagesArray() {
        viewModel.loadImagesFromRealm()
    }
    
    private func refreshScreen() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
//    func fetchAndUpdate() {
//        viewModel.fetchCatImage { success, error  in
//            success ? DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            } : print("error")
//        }
//    }
    
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
    
    func scrollToLastImage() {
        guard let count = viewModel.catImages?.count, count > 0 else { return }
        let lastIndexPath = IndexPath(item: count - 1, section: 0)
        collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
    }
}

