import UIKit

final class RegisterViewController: UIViewController {
    private let viewModel: RegisterViewModel

    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let registerButton = UIButton(type: .system)

    init(viewModel: RegisterViewModel) {
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
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        registerButton.setTitle("Register", for: .normal)

        [emailTextField, passwordTextField, registerButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            emailTextField.widthAnchor.constraint(equalToConstant: 250),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),

            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }

    @objc private func registerTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        viewModel.register(email: email, password: password)
    }
}
