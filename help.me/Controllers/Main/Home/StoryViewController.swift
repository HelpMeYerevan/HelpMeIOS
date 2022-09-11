//
//  StoryViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/13/21.
//

import UIKit

public final class StoryViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var storiesCollectionView: UICollectionView!
    @IBOutlet private var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet private var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    // MARK: Properties
    private var stories: Stories?
    private var selectedStory: Story?
    private var counter: Double = 0
    private var timer: Timer?
    private var isScrolling = false
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        setupTimer()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = selectedStory?.indexPath {
            DispatchQueue.main.async {
                self.storiesCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            }
        }
    }
    
    // MARK: Methods
    public override func setupView() {
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.require(toFail: swipeGestureRecognizer)
    }
    
    private func setupCollectionViews() {
        storiesCollectionView.delegate = self
        storiesCollectionView.dataSource = self
        storiesCollectionView.register(FullscreenStoryCollectionViewCell.cellNibName, forCellWithReuseIdentifier: FullscreenStoryCollectionViewCell.cellIdentifier)
        
    }
    
    public func setStories(_ stories: Stories) {
        self.selectedStory = stories.data?.filter({ $0.indexPath != nil }).first
        self.stories = stories
    }
    
    private func setupTimer() {
        counter = Constants.defaultStoryShowingTime
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc private func updateCounter() {
        if counter > 1 {
            counter -= 1
        } else if counter == 1 {
            counter = Constants.defaultStoryShowingTime
            timer?.invalidate()
            if (self.stories?.data ?? []).count - 1 > (selectedStory?.indexPath?.item ?? 0) {
                let indexPath = IndexPath(item: (selectedStory?.indexPath?.item ?? 0) + 1, section: selectedStory?.indexPath?.section ?? 0)
                self.stories?.data?.enumerated().forEach({ (index, story) in
                    story.indexPath = nil
                    if index == indexPath.item {
                        story.indexPath = indexPath
                        selectedStory = story
                    }
                })
                storiesCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            } else {
                dismiss(animated: true)
            }
        }
    }
    
    public func reloadTimer() {
        timer?.invalidate()
        timer = nil
        setupTimer()
    }
    
    public func resetTimer() {
        counter = Constants.defaultStoryShowingTime
        timer?.invalidate()
        timer = nil
    }
    
    private func dismissStory() {
        resetTimer()
        dismiss(animated: true)
    }
    
    // MARK: Action
    @IBAction private func dismissButtonAction(_ sender: UIButton) {
        dismissStory()
    }
    
    @IBAction private func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            self.storiesCollectionView.scrollToItem(at: self.selectedStory?.indexPath ?? IndexPath(item: 0, section: 0), at: .left, animated: true)
        }
        self.reloadTimer()
    }
    
    @IBAction private func swipeGestureRecognizerAction(_ sender: UISwipeGestureRecognizer) {
        dismissStory()
    }
}

// MARK: UICollectionViewDelegate
extension StoryViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.item)
//        isScrolling = false
        view.isUserInteractionEnabled = true
        reloadTimer()
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension StoryViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
}

// MARK: UICollectionViewDataSource
extension StoryViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories?.data?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullscreenStoryCollectionViewCell.cellIdentifier, for: indexPath) as? FullscreenStoryCollectionViewCell, let story = stories?.data?[indexPath.item] else { return UICollectionViewCell() }
        cell.setData(from: story)
        cell.readMoreButtonDidTapped = { [unowned self] in
            guard let urlString = selectedStory?.link else { return }
            let url = URL(string: urlString)
            self.open(url)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.resetTimer()
                self.dismiss(animated: false)
            })
        }
        return cell
    }
    
    
}

// MARK: UIScrollViewDelegate
extension StoryViewController {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.reloadTimer()
            for cell in self.storiesCollectionView.visibleCells {
                let indexPath = self.storiesCollectionView.indexPath(for: cell)
                self.stories?.data?.enumerated().forEach({ (index, story) in
                    story.indexPath = nil
                    if index == indexPath?.item {
                        story.indexPath = indexPath
                        self.selectedStory = story
                    }
                })
                self.storiesCollectionView.reloadData()
            }
        }
    }
}

// MARK: UIGestureRecognizerDelegate
extension StoryViewController {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: view)
//        if !isScrolling {
            if point.x > UIScreen.main.bounds.width / 2 {
                if selectedStory?.id != stories?.data?.last?.id {
                    view.isUserInteractionEnabled = false
//                    isScrolling = true
                    let indexPath = IndexPath(item: (selectedStory?.indexPath?.item ?? 0) + 1, section: selectedStory?.indexPath?.section ?? 0)
                    stories?.data?.enumerated().forEach({ (index, story) in
                        story.indexPath = nil
                        if index == indexPath.item {
                            story.indexPath = indexPath
                            selectedStory = story
                        }
                    })
                }
            } else {
                if selectedStory?.id != stories?.data?.first?.id {
//                    isScrolling = true
                    view.isUserInteractionEnabled = false
                    let indexPath = IndexPath(item: (selectedStory?.indexPath?.item ?? 0) - 1, section: selectedStory?.indexPath?.section ?? 0)
                    stories?.data?.enumerated().forEach({ (index, story) in
                        story.indexPath = nil
                        if index == indexPath.item {
                            story.indexPath = indexPath
                            selectedStory = story
                        }
                    })
                }
            }
//        }
        return true
    }
}
