import UIKit
import FLAnimatedImage

public protocol OnboardingViewControllerDelegate: AnyObject {
    func onboardingDidFinish()
}

public class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    public var onboardingDelegate: OnboardingViewControllerDelegate?
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    let skipButton = UIButton(type: .system)
    let getStartedButton = UIButton(type: .system)
    let onboardingPages: [OnboardingPage]
    var showGetStartedBtn: [NSLayoutConstraint] = [NSLayoutConstraint]()

    public init(onboardingPages: [OnboardingPage]) {
       self.onboardingPages = onboardingPages
       super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPages()
    }

  
    func setUpPages() {
        scrollView.frame = view.bounds
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(onboardingPages.count), height: view.bounds.height)
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.backgroundColor = .black
        skipButton.layer.cornerRadius = 15
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            skipButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        skipButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)

        for (index, page) in onboardingPages.enumerated() {
            let pageView = UIView(frame: CGRect(x: view.bounds.width * CGFloat(index), y: 0, width: view.bounds.width, height: view.bounds.height))
            pageView.backgroundColor = page.backgroundColor

            let titleLabel = UILabel(frame: .zero)
            titleLabel.text = page.title
            titleLabel.textAlignment = .center
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            pageView.addSubview(titleLabel)
            
            let imageView = FLAnimatedImageView(frame: .zero)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            guard let url = Bundle.module.path(forResource: page.imageName, ofType: "gif") else {
                print("Local image not found")
                return
            }
         
            let resourceURL = URL(fileURLWithPath: url)
            if let gifData = try? Data(contentsOf: resourceURL) {
                let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
                imageView.animatedImage = animatedImage
                pageView.addSubview(imageView)
            }
            
            let txtDescription = UILabel(frame: .zero)
            txtDescription.text = page.description
            txtDescription.translatesAutoresizingMaskIntoConstraints = false
            txtDescription.textAlignment = .justified
            txtDescription.numberOfLines = 0
            txtDescription.textColor = .gray
            txtDescription.font = .systemFont(ofSize: 14, weight: .semibold)
            pageView.addSubview(txtDescription)
            
            scrollView.addSubview(pageView)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: skipButton.safeAreaLayoutGuide.bottomAnchor, constant: 10),
                titleLabel.leadingAnchor.constraint(equalTo: pageView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                titleLabel.trailingAnchor.constraint(equalTo: pageView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                imageView.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10),
                imageView.trailingAnchor.constraint(equalTo: pageView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                imageView.leadingAnchor.constraint(equalTo: pageView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                imageView.bottomAnchor.constraint(equalTo: txtDescription.safeAreaLayoutGuide.topAnchor, constant: -30),
                imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 500),
                txtDescription.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
                txtDescription.trailingAnchor.constraint(equalTo: pageView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                txtDescription.leadingAnchor.constraint(equalTo: pageView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
               
            ])
        }
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = onboardingPages.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        view.addSubview(pageControl)
    
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        getStartedButton.setTitle("Get started", for: .normal)
        getStartedButton.setTitleColor(.white, for: .normal)
        getStartedButton.backgroundColor = .black
        getStartedButton.layer.cornerRadius = 15
        getStartedButton.addTarget(self, action: #selector(getStartedButtonTapped), for: .touchUpInside)
        getStartedButton.isHidden = true
        view.addSubview(getStartedButton)
        
        
        showGetStartedBtn = [
            getStartedButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -10),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ]
        
        NSLayoutConstraint.deactivate(showGetStartedBtn)
        
        getStartedButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    }

    // MARK: - Actions

    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let contentOffsetX = scrollView.bounds.width * CGFloat(currentPage)
        scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: true)
    }
    
    @objc func skipButtonTapped() {
        onboardingDelegate?.onboardingDidFinish()
   }

    @objc func getStartedButtonTapped() {
        onboardingDelegate?.onboardingDidFinish()
    }

    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let currentPage = round(scrollView.contentOffset.x / scrollView.bounds.width)
       pageControl.currentPage = Int(currentPage)
        
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let isLastPage = currentPage == onboardingPages.count - 1
        if isLastPage {
            getStartedButton.isHidden = false
            NSLayoutConstraint.activate(showGetStartedBtn)
        } else {
            pageControl.currentPage = Int(currentPage)
            
        }
    }
}


