import UIKit

final class CalendarView: UIView {
    var onDateSelected: ((Date) -> Void)?

    private let datePicker = UIDatePicker()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .inline
        addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }

    @objc private func dateChanged() {
        onDateSelected?(datePicker.date)
    }
}
