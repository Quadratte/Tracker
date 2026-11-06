import UIKit

final class TrackerCell: UICollectionViewCell {

    static let id = String(describing: TrackerCell.self)

    // MARK: - UI
    private let cardView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()

    private let emojiLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 16)
        l.textAlignment = .center
        l.backgroundColor = .white.withAlphaComponent(0.3)
        l.layer.cornerRadius = 12
        l.clipsToBounds = true
        return l
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 12, weight: .medium)
        l.textColor = .white
        l.numberOfLines = 2
        return l
    }()

    private let countLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 12)
        l.textColor = .black
        return l
    }()

    private let plusButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "plus"), for: .normal)
        b.tintColor = .white
        b.layer.cornerRadius = 17
        return b
    }()

    // MARK: - Callback
    var onPlusTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        plusButton.addAction(UIAction { [weak self] _ in
            self?.onPlusTapped?()
        }, for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(emojiLabel)
        cardView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(plusButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),

            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),

            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            countLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),

            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    // MARK: - Configure
    func configure(with tracker: Tracker, isCompleted: Bool, count: Int) {
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        countLabel.text = "\(count) дней"
        cardView.backgroundColor = UIColor(named: tracker.colorName) ?? .systemBlue
        plusButton.backgroundColor = cardView.backgroundColor

        let imageName = isCompleted ? "checkmark" : "plus"
        plusButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
