import UIKit
import SnapKit
import WACore

class TimeSettingViewController: UIViewController, AppParameters {
    
    private var viewModel: TimeSettingViewModel!
    private var viewModelCat: CatHistoryViewModel! // для теста, так-то оно тут не должно быть
    private let timePickerOne = UIDatePicker()
    private let timePickerTwo = UIDatePicker()
    private let labelOne = UILabel()
    private let labelTwo = UILabel()
    private let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TimeSettingViewModel()
        viewModelCat = CatHistoryViewModel()
        setupUI()
        configureConstraints()
    }
}

// MARK: - Configure UI
private extension TimeSettingViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        configureLabel(labelOne, withText: "Время первого уведомления")
        configureLabel(labelTwo, withText: "Время второго уведомления")
        configureTimePicker(timePickerOne, forKey: AppKeys.timeOne)
        configureTimePicker(timePickerTwo, forKey: AppKeys.timeTwo)
        configureSaveButton()
    }
    
    func configureLabel(_ label: UILabel, withText text: String) {
        label.text = text
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.backgroundColor = .secondarySystemBackground
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        view.addSubview(label)
    }
    
    func configureTimePicker(_ timePicker: UIDatePicker, forKey: AppParameterKey) {
        timePicker.datePickerMode = .time
        if #available(iOS 14, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        let savedTime = params.get(forKey, type: Date.self).value
        timePicker.date = savedTime ?? Date()
        
        view.addSubview(timePicker)
    }
    
    func configureSaveButton() {
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        saveButton.layer.cornerRadius = 15
        saveButton.backgroundColor = UIColor.systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
    }
    
    func configureConstraints() {
        labelOne.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.height.equalTo(35)
            $0.width.equalToSuperview().inset(40)
            $0.centerX.equalTo(view)
        }
        
        timePickerOne.snp.makeConstraints {
            $0.top.equalTo(labelOne.snp.bottom).offset(10)
            $0.centerX.equalTo(view)
        }
        
        labelTwo.snp.makeConstraints {
            $0.top.equalTo(timePickerOne.snp.bottom).offset(30)
            $0.height.equalTo(35)
            $0.width.equalToSuperview().inset(40)
            $0.centerX.equalTo(view)
        }
        
        timePickerTwo.snp.makeConstraints {
            $0.top.equalTo(labelTwo.snp.bottom).offset(10)
            $0.centerX.equalTo(view)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(timePickerTwo.snp.bottom).offset(30)
            $0.centerX.equalTo(view)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
}

// MARK: - Configure Actions
private extension TimeSettingViewController {
    
    @objc func saveButtonTapped() {
        viewModel.timeOne = timePickerOne.date
        viewModel.timeTwo = timePickerTwo.date
        viewModel.saveTimeSettings()
        viewModel.showAlert = {
            print("ShowControllerAlert")
            DispatchQueue.main.async {  [self] in
                showAlertWhenDisabled()
                configureTimePicker(timePickerOne, forKey: AppKeys.timeOne)
                configureTimePicker(timePickerTwo, forKey: AppKeys.timeTwo)
            }
        }
//        viewModelCat.fetchCatImageWANetwork {success, error in
//            print("fetched")
//        }
        // для теста, так-то оно тут не должно быть
        //                viewModelCat.fetchCatImageAlamoFire { success, error in
        //                    print("fetched")
        //                }
    }
    func showAlertWhenDisabled() {
        let alert = UIAlertController(
            title: "Уведомления отключены",
            message: "Уведомления отключены в настройках. Чтобы получать напоминания, пожалуйста, включите уведомления для этого приложения в настройках вашего устройства.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Настройки", style: .default, handler: { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        self.present(alert, animated: true)
    }
}
