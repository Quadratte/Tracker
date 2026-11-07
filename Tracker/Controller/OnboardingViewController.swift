import UIKit

final class OnboardingViewController: UIPageViewController {

    private let pages: [(title: String, imageName: String)] = [
        ("Отслеживайте только то, что хотите", "ilBackground1"),
        ("Даже если это не литры воды и йога", "ilBackground2")
    ]

    private var currentIndex = 0

    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .lightGray
        pc.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.goToPage(self.pageControl.currentPage)
        }, for: .valueChanged)
        return pc
    }()

    private lazy var skipButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Вот это технологии!", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .black
        b.layer.cornerRadius = 16
        b.addAction(UIAction { [weak self] _ in
            self?.finishOnboarding()
        }, for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupUI()
        setupConstraints()
    }

    private func setupPageViewController() {
        dataSource = self
        delegate = self
        setViewControllers([makePage(index: 0)], direction: .forward, animated: false)
    }

    private func makePage(index: Int) -> UIViewController {
        let vc = UIViewController()
        vc.view.tag = index
        vc.view.backgroundColor = .white

        let imageView = UIImageView(image: UIImage(named: pages[index].imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = pages[index].title
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center

        vc.view.addSubview(imageView)
        vc.view.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),

            label.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: -270)
        ])

        return vc
    }

    private func setupUI() {
        view.addSubview(pageControl)
        view.addSubview(skipButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            skipButton.heightAnchor.constraint(equalToConstant: 60),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -24)
        ])
    }

    private func goToPage(_ index: Int) {
        guard index >= 0, index < pages.count, index != currentIndex else { return }
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        setViewControllers([makePage(index: index)], direction: direction, animated: true)
        currentIndex = index
        pageControl.currentPage = index
    }

    private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        guard let window = view.window else { return }
        window.rootViewController = TabBarController()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let index = currentIndex - 1
        return index >= 0 ? makePage(index: index) : nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let index = currentIndex + 1
        return index < pages.count ? makePage(index: index) : nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed, let current = viewControllers?.first else { return }
        let index = current.view.tag
        currentIndex = index
        pageControl.currentPage = index
    }
}
