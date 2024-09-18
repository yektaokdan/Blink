import UIKit

class CustomSearchBar: UIView {
    private let searchTextField = UITextField()
    var onSearchTextChanged: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        searchTextField.placeholder = "Haberlerde ara..."
        searchTextField.layer.cornerRadius = 20
        searchTextField.borderStyle = .roundedRect
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        onSearchTextChanged?(textField.text ?? "")
    }
}
