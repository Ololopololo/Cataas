import UIKit

func createDefaultButton(title: String) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.layer.cornerRadius = 25
    button.tintColor = .white
    button.backgroundColor = UIColor(red: 0/255, green: 90/255, blue: 190/255, alpha: 1.0)
    return button
}


