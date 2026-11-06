import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectSchedule(_ days: [Weekday])
}

final class ScheduleViewController: UIViewController {

    weak var delegate: ScheduleViewControllerDelegate?
    var selectedDays: [Weekday] = []

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 16
        tv.isScrollEnabled = false
        return tv
    }()

    private let doneButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Готово", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .systemBlue
        b.layer.cornerRadius = 16
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Расписание"
        setupUI()
        setupConstraints()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        doneButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.delegate?.didSelectSchedule(self.selectedDays)
            self.dismiss(animated: true)
        }, for: .touchUpInside)
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(doneButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(Weekday.allCases.count) * 52),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Weekday.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let day = Weekday.allCases[indexPath.row]
        cell.textLabel?.text = day.shortName
        cell.selectionStyle = .none

        let toggle = UISwitch()
        toggle.isOn = selectedDays.contains(day)
        toggle.tag = day.rawValue
        toggle.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            if toggle.isOn {
                if !self.selectedDays.contains(day) {
                    self.selectedDays.append(day)
                }
            } else {
                self.selectedDays.removeAll { $0 == day }
            }
        }, for: .valueChanged)

        cell.accessoryView = toggle
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        52
    }
}
