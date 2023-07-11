import UIKit
import FLAnimatedImage

public protocol OnboardingViewControllerDelegate: AnyObject {
    func onboardingDidFinish(_ onboardingViewController: OnboardingViewController)
}

public class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public var onboardingDelegate: OnboardingViewControllerDelegate?
    let onboardingPages: [OnboardingPage]
    let skipButton = UIButton(type: .system)
    let nextButton = UIButton(type: .system)
    let pageControl = UIPageControl()
    let titleLabel = UILabel(frame: .zero)
    let txtDescription = UILabel(frame: .zero)
    let imageView = FLAnimatedImageView(frame: .zero)
    
    public override func viewDidLoad() {
         super.viewDidLoad()

         dataSource = self
         delegate = self
        setupUI()
         if let firstPage = onboardingPages.first {
             setViewControllers([createOnboardingViewController(for: firstPage)], direction: .forward, animated: true, completion: nil)
         }

     }

    public init(onboardingPages: [OnboardingPage]) {
          self.onboardingPages = onboardingPages
          super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
    
    func createOnboardingViewController(for page: OnboardingPage) -> UIViewController {
        let onboardingViewController = UIViewController()
        onboardingViewController.view.backgroundColor = page.backgroundColor

        titleLabel.text = page.title
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        txtDescription.text = page.description
        txtDescription.translatesAutoresizingMaskIntoConstraints = false
        txtDescription.textAlignment = .justified
        txtDescription.numberOfLines = 0
        txtDescription.textColor = .gray
        txtDescription.font = .systemFont(ofSize: 14, weight: .semibold)
       
        onboardingViewController.view.addSubview(titleLabel)
        onboardingViewController.view.addSubview(txtDescription)
        
        imageView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let url = Bundle.module.path(forResource: page.imageName, ofType: "gif") {
            
            let resourceURL = URL(fileURLWithPath: url)
            if let gifData = try? Data(contentsOf: resourceURL) {
                let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
                imageView.animatedImage = animatedImage
                onboardingViewController.view.addSubview(imageView)
            }
        }
        
    
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: onboardingViewController.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: onboardingViewController.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: onboardingViewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: onboardingViewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imageView.leadingAnchor.constraint(equalTo: onboardingViewController.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: txtDescription.topAnchor, constant: -30),
            imageView.heightAnchor.constraint(equalToConstant: 400),
            txtDescription.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            txtDescription.trailingAnchor.constraint(equalTo: onboardingViewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            txtDescription.leadingAnchor.constraint(equalTo: onboardingViewController.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
        ])
        
        
        return onboardingViewController
    }
    

     func setupUI() {

         skipButton.translatesAutoresizingMaskIntoConstraints = false
         skipButton.setTitle("Skip", for: .normal)
         skipButton.setTitleColor(.white, for: .normal)
         skipButton.backgroundColor = .lightGray
         skipButton.layer.cornerRadius = 15
         skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
         
         nextButton.translatesAutoresizingMaskIntoConstraints = false
         nextButton.setTitle("Next", for: .normal)
         nextButton.setTitleColor(.white, for: .normal)
         nextButton.backgroundColor = .black
         nextButton.layer.cornerRadius = 15
         nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
         
         pageControl.translatesAutoresizingMaskIntoConstraints = false
         pageControl.numberOfPages = onboardingPages.count
         pageControl.pageIndicatorTintColor = .lightGray
         pageControl.currentPageIndicatorTintColor = .black
         
         pageControl.numberOfPages = onboardingPages.count
         pageControl.currentPage = 0
         
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        view.addSubview(pageControl)
  
         NSLayoutConstraint.activate([
             skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
             skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
             skipButton.heightAnchor.constraint(equalToConstant: 30),
             nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
             nextButton.bottomAnchor.constraint(equalTo: pageControl.safeAreaLayoutGuide.topAnchor, constant: -40),
             pageControl.topAnchor.constraint(equalTo: nextButton.safeAreaLayoutGuide.bottomAnchor, constant: 10),
             pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
             pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         ])

         NSLayoutConstraint.activate([
             pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
         ])
         
         skipButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
         nextButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
     }
    

        // MARK: - UIPageViewControllerDataSource

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let currentIndex = onboardingViewControllerIndex(viewController),
                  currentIndex > 0 else {
                return nil
            }

            let previousIndex = currentIndex - 1
            return createOnboardingViewController(for: onboardingPages[previousIndex])
        }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let currentIndex = onboardingViewControllerIndex(viewController),
                  currentIndex < onboardingPages.count - 1 else {
                return nil
            }

            let nextIndex = currentIndex + 1
            return createOnboardingViewController(for: onboardingPages[nextIndex])
        }

        // MARK: - Helper Methods

        func onboardingViewControllerIndex(_ viewController: UIViewController) -> Int? {
            return onboardingPages.firstIndex { $0.title == viewController.title }
        }
    
    // MARK: - Actions

    @objc func nextPage() {
        guard let currentViewController = viewControllers?.first else {
            return
        }

        if let currentIndex = onboardingPages.firstIndex(where: { $0.title == (currentViewController.view.subviews.first { $0 is UILabel } as? UILabel)?.text }),
           currentIndex < onboardingPages.count-1 {
            var nextIndex = currentIndex + 1
            if  nextIndex == onboardingPages.count-1 {
                nextIndex = currentIndex + 1
                nextButton.setTitle("Get started", for: .normal)
                let nextViewController = createOnboardingViewController(for: onboardingPages[nextIndex])
                setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
                pageControl.currentPage = nextIndex
            } else {
                let nextViewController = createOnboardingViewController(for: onboardingPages[nextIndex])
                setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
                pageControl.currentPage = nextIndex
            }
        } else {
            onboardingDelegate?.onboardingDidFinish(self)
        }
     
    }
    
    @objc func skipButtonTapped() {
        onboardingDelegate?.onboardingDidFinish(self)
    }
}
