import UIKit

final class KanbanColumnView: UIView {
    private let titleLabel = UILabel()
    private let stackView = UIStackView()

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        clipsToBounds = true

        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center

        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let titleContainer = UIView()
        titleContainer.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: -8)
        ])

        let container = UIStackView(arrangedSubviews: [titleContainer, stackView])
        container.axis = .vertical
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    func configure(with tasks: [Task]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for task in tasks {
            let taskView = KanbanTaskView(task: task)
            stackView.addArrangedSubview(taskView)
        }
    }
}
