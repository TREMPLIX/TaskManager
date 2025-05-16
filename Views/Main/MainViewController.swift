import UIKit

final class MainViewController: UIViewController {
    private let viewModel: MainViewModel
    private let sidebarVC: SidebarViewController
    private let contentContainer = UIView()

    init(viewModel: MainViewModel, sidebarVC: SidebarViewController) {
        self.viewModel = viewModel
        self.sidebarVC = sidebarVC
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        bindSidebarSelection()
        sidebarVC.selectFirstSection()
    }

    private func setupLayout() {
        addChild(sidebarVC)
        sidebarVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sidebarVC.view)
        sidebarVC.didMove(toParent: self)

        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentContainer)

        NSLayoutConstraint.activate([
            sidebarVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sidebarVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            sidebarVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sidebarVC.view.widthAnchor.constraint(equalToConstant: 250),

            contentContainer.leadingAnchor.constraint(equalTo: sidebarVC.view.trailingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: view.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func displayContent(_ viewController: UIViewController) {
        children
            .filter { $0 != sidebarVC }
            .forEach {
                $0.willMove(toParent: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParent()
            }

        addChild(viewController)
        contentContainer.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
        ])
        viewController.didMove(toParent: self)
    }
    
    private func bindSidebarSelection() {
        sidebarVC.didSelectSection = { [weak self] section in
            self?.viewModel.select(section: section)
            
            let labelVC = UIViewController()
            labelVC.view.backgroundColor = .white
            let label = UILabel()
            label.text = section.title
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 24, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            labelVC.view.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: labelVC.view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: labelVC.view.centerYAnchor)
            ])
            
            self?.displayContent(labelVC)
        }
    }
}
