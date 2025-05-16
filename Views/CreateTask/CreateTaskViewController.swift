import UIKit

final class CreateTaskViewController: UIViewController {
    private let viewModel: CreateTaskViewModel
    private let textField = UITextField()
    private let createButton = UIButton(type: .system)

    init(viewModel: CreateTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        textField.placeholder = "Task Title"
        textField.borderStyle = .roundedRect
        createButton.setTitle("Create Task", for: .normal)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [textField, createButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    @objc private func createTapped() {
        guard let title = textField.text, !title.isEmpty else { return }
        viewModel.createTask(title: title)
        dismiss(animated: true)
    }
}
