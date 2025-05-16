import UIKit

final class TaskDetailViewController: UIViewController {
    private let viewModel: TaskDetailViewModel

    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    private let dueDatePicker = UIDatePicker()
    private let saveButton = UIButton(type: .system)

    init(viewModel: TaskDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadTask()
        fillData()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Task Details"

        titleTextField.placeholder = "Task Title"
        titleTextField.borderStyle = .roundedRect

        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 8

        dueDatePicker.datePickerMode = .dateAndTime

        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleTextField, descriptionTextView, dueDatePicker, saveButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func fillData() {
        guard let task = viewModel.task else { return }
        titleTextField.text = task.title
        descriptionTextView.text = task.description
        if let date = task.dueDate {
            dueDatePicker.date = date
        }
    }

    @objc private func saveTapped() {
        viewModel.updateTask(
            title: titleTextField.text ?? "",
            description: descriptionTextView.text,
            dueDate: dueDatePicker.date
        )
        navigationController?.popViewController(animated: true)
    }
}
