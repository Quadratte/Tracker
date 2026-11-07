import UIKit

final class TrackersViewController: UIViewController {

    var categories: [TrackerCategory] = []
    var completedTrackers: Set<TrackerRecord> = []
    var currentDate: Date = Date()

    private var visibleTrackers: [Tracker] {
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        return categories.flatMap { $0.trackers }.filter { tracker in
            tracker.schedule.contains { $0.calendarWeekday == weekday }
        }
    }

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: (width - 32 - 7) / 2, height: 120)
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .compact
        dp.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.currentDate = self.datePicker.date
            self.updateUI()
        }, for: .valueChanged)
        return dp
    }()

    let stubImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = .ilerror
        return iv
    }()

    let stubLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Что будем отслеживать?"
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavBar()
        setupCollection()
        setupConstraints()
        updateUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(stubImage)
        view.addSubview(stubLabel)
    }

    private func setupCollection() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.id)
        collectionView.backgroundColor = .clear
    }

    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"

        let leftButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            primaryAction: UIAction { [weak self] _ in
                self?.addTracker()
            })
        navigationItem.leftBarButtonItem = leftButton

        let rightButton = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = rightButton
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stubImage.heightAnchor.constraint(equalToConstant: 80),
            stubImage.widthAnchor.constraint(equalToConstant: 80),

            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func updateUI() {
        let isEmpty = visibleTrackers.isEmpty
        stubImage.isHidden = !isEmpty
        stubLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
        collectionView.reloadData()
    }

    private func addTracker() {
        let vc = TrackerCreationViewController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }

    private func toggleTracker(_ tracker: Tracker) {
        if currentDate > Date() { return }

        if let index = completedTrackers.firstIndex(where: {
            $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate)
        }) {
            completedTrackers.remove(at: index)
        } else {
            completedTrackers.insert(TrackerRecord(date: currentDate, id: tracker.id))
        }
        collectionView.reloadData()
    }
}

extension TrackersViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleTrackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.id, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }

        let tracker = visibleTrackers[indexPath.row]
        let isCompleted = completedTrackers.contains {
            $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate)
        }
        let count = completedTrackers.filter { $0.id == tracker.id }.count

        cell.configure(with: tracker, isCompleted: isCompleted, count: count)
        cell.onPlusTapped = { [weak self] in
            self?.toggleTracker(tracker)
        }
        return cell
    }
}

extension TrackersViewController: TrackerCreationDelegate {
    func didCreateTracker(_ tracker: Tracker) {
        if let index = categories.firstIndex(where: { $0.header == "Мои трекеры" }) {
            let category = categories[index]
            let newCategory = TrackerCategory(header: category.header, trackers: category.trackers + [tracker])
            var newCategories = categories
            newCategories[index] = newCategory
            categories = newCategories
        } else {
            categories.append(TrackerCategory(header: "Мои трекеры", trackers: [tracker]))
        }
        updateUI()
    }
}
