import UIKit

final class CustomCell: UICollectionViewCell {

    static let id = String(describing: CustomCell.self)
    let label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupCell()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func setupCell() {
        contentView.backgroundColor = .green
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

        ])
    }
}
