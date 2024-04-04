import UIKit
import SnapKit

class FullScreenImageViewController: UIViewController {
    private var imageData: Data
    private let imageView = UIImageView()
    
    // Инициализатор с imageData
    init(imageData: Data) {
        self.imageData = imageData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        imageView.image = UIImage(data: imageData)
        
        
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        imageView.contentMode = .scaleAspectFit
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let backButton = UIButton(type: .system)
        backButton.setTitle("Назад", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(44)
        }
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func imageTapped() {
        let newBackgroundColor: UIColor = view.backgroundColor == .white ? .black : .white
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.view.backgroundColor = newBackgroundColor
        }
    }
}

