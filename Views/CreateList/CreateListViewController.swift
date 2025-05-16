import UIKit

final class CreateListViewController: UIViewController {
    private let viewModel: CreateListViewModel

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Название списка"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let colorPicker: UISegmentedControl = {
        let colors = ["🔴", "🟢", "🔵", "🟡", "🟣"]
        let control = UISegmentedControl(items: colors)
        control.selectedSegmentIndex = 0
        return control
    }()

    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    init(viewModel: CreateListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Создание списка"
        view.backgroundColor = .systemBackground
        setupUI()
        createButton.addTarget(self, action: #selector(createList), for: .touchUpInside)
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [nameTextField, colorPicker, createButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc private func createList() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        let selectedColorIndex = colorPicker.selectedSegmentIndex
        viewModel.createList(with: name)
    }
}
