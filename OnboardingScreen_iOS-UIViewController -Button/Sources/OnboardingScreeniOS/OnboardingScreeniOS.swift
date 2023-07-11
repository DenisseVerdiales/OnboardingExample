import UIKit
import FLAnimatedImage

public protocol OnboardingViewControllerDelegate: AnyObject {
    func onboardingDidFinish()
}

public class OnboardingViewController: UIViewController {
    public var onboardingDelegate: OnboardingViewControllerDelegate?
    let pageControl = UIPageControl()
    let skipButton = UIButton(type: .system)
    let nextButton = UIButton(type: .system)
    let onboardingPages: [OnboardingPage]
    var currentPageIndex = 0
    
    public init(onboardingPages: [OnboardingPage]) {
       self.onboardingPages = onboardingPages
       super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = onboardingPages[currentPageIndex].backgroundColor
        setUpUI()
    }
    
    func setUpUI() {
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
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = onboardingPages.count
        pageControl.currentPage = currentPageIndex
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = onboardingPages[currentPageIndex].title
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        
        let txtDescription = UILabel(frame: .zero)
        txtDescription.text = onboardingPages[currentPageIndex].description
        txtDescription.translatesAutoresizingMaskIntoConstraints = false
        txtDescription.textAlignment = .justified
        txtDescription.numberOfLines = 0
        txtDescription.textColor = .gray
        txtDescription.font = .systemFont(ofSize: 14, weight: .semibold)
       
        view.addSubview(skipButton)
        view.addSubview(titleLabel)
        view.addSubview(txtDescription)
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        
        let imageView = FLAnimatedImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        guard let url = Bundle.module.path(forResource: onboardingPages[currentPageIndex].imageName, ofType: "gif") else {
            print("Local image not found")
            return
        }
     
        let resourceURL = URL(fileURLWithPath: url)
        if let gifData = try? Data(contentsOf: resourceURL) {
            let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
            imageView.animatedImage = animatedImage
            view.addSubview(imageView)
        }
        
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
           // skipButton.widthAnchor.constraint(equalToConstant: 60),
            titleLabel.topAnchor.constraint(equalTo: skipButton.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: txtDescription.topAnchor, constant: -30),
            txtDescription.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            txtDescription.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -10),
            txtDescription.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            txtDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            nextButton.topAnchor.constraint(equalTo: txtDescription.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            pageControl.topAnchor.constraint(equalTo: nextButton.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
        
        skipButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nextButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
    }
    
    @objc func skipButtonTapped() {
        onboardingDelegate?.onboardingDidFinish()
    }
    
    @objc func nextButtonTapped() {
        // Remove previous label and image view from the view hierarchy
        view.subviews.filter { $0 is UILabel || $0 is UIImageView }.forEach { $0.removeFromSuperview() }

        if currentPageIndex < onboardingPages.count {
            currentPageIndex += 1
            
            if currentPageIndex == onboardingPages.count-1 {
                
                view.backgroundColor = onboardingPages[currentPageIndex].backgroundColor
                pageControl.currentPage = currentPageIndex
                
                setUpUI()
                nextButton.setTitle("Get started", for: .normal)
                currentPageIndex += 1
            } else {
                
                view.backgroundColor = onboardingPages[currentPageIndex].backgroundColor
                pageControl.currentPage = currentPageIndex
                setUpUI()
            }
            
        } else {
            onboardingDelegate?.onboardingDidFinish()
        }
    }
}
