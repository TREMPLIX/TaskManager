import UIKit

final class NoteDetailViewController: UIViewController {
    private let viewModel: NoteDetailViewModel

    init(viewModel: NoteDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.note.title
    }
}
