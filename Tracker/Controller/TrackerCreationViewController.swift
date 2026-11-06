import UIKit

protocol TrackerCreationDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker)
}

final class TrackerCreationViewController: UIViewController {

    weak var delegate: TrackerCreationDelegate?

    private var selectedSchedule: [Weekday] = []
    private var selectedEmoji: String = "😀"
    private var selectedColor: String = "Color1"

    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Введите название трекера"
        tf.backgroundColor = .systemGray6
        tf.layer.cornerRadius = 16
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        return tf
    }()

    private let categoryButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Категория", for: .normal)
        b.contentHorizontalAlignment = .left
        b.backgroundColor = .systemGray6
        b.layer.cornerRadius = 16
        b.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return b
    }()

    private let scheduleButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Расписание", for: .normal)
        b.contentHorizontalAlignment = .left
        b.backgroundColor = .systemGray6
        b.layer.cornerRadius = 16
        b.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return b
    }()

    private let cancelButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Отменить", for: .normal)
        b.setTitleColor(.systemRed, for: .normal)
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.systemRed.cgColor
        b.layer.cornerRadius = 16
        return b
    }()

    private let createButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Создать", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .systemGray
        b.layer.cornerRadius = 16
        b.isEnabled = false
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupUI()
        setupConstraints()
        setupActions()
        setupKeyboardDismiss()
    }

    private func setupNavBar() {
        navigationItem.title = "Новая привычка"
    }

    private func setupUI() {
        view.addSubview(nameTextField)
        view.addSubview(categoryButton)
        view.addSubview(scheduleButton)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),

            categoryButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),

            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 16),
            scheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),

            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.42),

            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.42)
        ])
    }

    private func setupActions() {
        nameTextField.addAction(UIAction { [weak self] _ in
            self?.updateCreateButtonState()
        }, for: .editingChanged)

        cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)

        createButton.addAction(UIAction { [weak self] _ in
            self?.createTracker()
        }, for: .touchUpInside)

        scheduleButton.addAction(UIAction { [weak self] _ in
            self?.openSchedule()
        }, for: .touchUpInside)

        categoryButton.addAction(UIAction { _ in
            print("Category tapped")
        }, for: .touchUpInside)
    }

    private func updateCreateButtonState() {
        let hasName = !(nameTextField.text?.isEmpty ?? true)
        createButton.isEnabled = hasName
        createButton.backgroundColor = hasName ? .systemBlue : .systemGray
    }

    private func openSchedule() {
        let vc = ScheduleViewController()
        vc.selectedDays = selectedSchedule
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }

    private func createTracker() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        let tracker = Tracker(
            id: UUID(),
            name: name,
            colorName: selectedColor,
            emoji: selectedEmoji,
            schedule: selectedSchedule
        )
        delegate?.didCreateTracker(tracker)
        dismiss(animated: true)
    }

    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension TrackerCreationViewController: ScheduleViewControllerDelegate {
    func didSelectSchedule(_ days: [Weekday]) {
        selectedSchedule = days
    }
}
