//
//  PagerScrollView.swift
//  CustomPageableCollectionView
//
//  Created by Andreas Verhoeven on 21/05/2021.
//

import UIKit

internal class PagerScrollView: UIScrollView {
	weak var parent: UIScrollView?

	private var ignorePagerBoundsChange = false
	private var ignoreBoundsChange: Bool { ignoreParentChangesCount > 0 }
	private var ignoreParentChangesCount = 0
	
	public func ignoreParentChanges(_ callback: () -> Void) {
		ignoreParentChangesCount += 1
		callback()
		ignoreParentChangesCount -= 1
	}

	init(parent: UIScrollView) {
		self.parent = parent
		super.init(frame: .zero)
		setup()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("not implemented")
	}

	// The paging configuration
	var configuration = PagingConfiguration(size: .full) {
		didSet {
			guard configuration != oldValue else { return }
			updateScrollViewProperties()
			updateParentContentOffset()
		}
	}

	public func updateSize() {
		guard let parent = parent else { return }
		bounds = configuration.resolvedPagerBounds(for: parent, pager: self)
		contentSize = parent.contentSize
		updateParentContentOffset()
	}

	public func updateForBoundsChange() {
		guard let parent = parent else { return }
		guard ignoreBoundsChange == false else { return }
		ignorePagerBoundsChange = true
		contentOffset = configuration.pagerContentOffset(for: contentOffset, in: parent, pager: self)
		ignorePagerBoundsChange = false
	}

	public func update() {
		guard let parent = parent else { return }
		isScrollEnabled = parent.isScrollEnabled
		alwaysBounceVertical = parent.alwaysBounceVertical
		alwaysBounceHorizontal = parent.alwaysBounceHorizontal
		showsVerticalScrollIndicator = false
		showsHorizontalScrollIndicator = false
		scrollsToTop = false
		decelerationRate = parent.decelerationRate
		bounces = parent.bounces
		bouncesZoom = parent.bouncesZoom
		isDirectionalLockEnabled = parent.isDirectionalLockEnabled

		updateGestureRecognizers()
	}
	
	public func updateGestureRecognizers() {
		guard let parent = parent else { return }
		panGestureRecognizer.isEnabled = parent.isPagingEnabled
		parent.panGestureRecognizer.isEnabled = (parent.isPagingEnabled == false)
	}

	// MARK: - Private
	private func setup() {
		delegate = self
		isHidden = true
		contentInsetAdjustmentBehavior = .never
		isPagingEnabled = true
		isUserInteractionEnabled = false
		panGestureRecognizer.isEnabled = false
		scrollsToTop = false

		let forwardingStopperScrollView = UIScrollView()
		forwardingStopperScrollView.isScrollEnabled = false
		forwardingStopperScrollView.addSubview(self)

		guard let parent = parent else { return }
		parent.scrollsToTop = false

		// we need to wrap our pager into another UIScrollView
		// that has scrolling disabled, otherwise UIKit will forward
		// our "scrolls" to our parent when we bounce, which confuses everyone.
		//
		// By adding a scroll view that cannot be scrolled in between, we stop
		// this forwarding.
		parent.addSubview(forwardingStopperScrollView)
		parent.addGestureRecognizer(panGestureRecognizer)
		updateScrollViewProperties()
	}

	private func updateParentContentOffset() {
		guard let parent = parent, parent.isPagingEnabled else { return }
		ignoreParentChanges {
			parent.contentOffset = configuration.resolvedContentOffset(for: parent, pager: self)
		}
	}

	// MARK: - UIView
	override var bounds: CGRect {
		didSet {
			updateParentContentOffset()
		}
	}
}

extension PagerScrollView: UIScrollViewDelegate {
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		guard let scrollView = parent else { return }
		parent?.delegate?.scrollViewWillBeginDragging?(scrollView)
	}

	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		guard let scrollView = parent else { return }
		parent?.delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
	}

	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		guard let scrollView = parent else { return }
		parent?.delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
	}


	func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
		guard let scrollView = parent else { return }
		parent?.delegate?.scrollViewWillBeginDecelerating?(scrollView)
	}

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		guard let scrollView = parent else { return }
		parent?.delegate?.scrollViewDidEndDecelerating?(scrollView)
	}


	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		guard let scrollView = parent else { return }
		parent?.delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
	}


	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		guard let scrollView = self.parent else { return nil }
		return parent?.delegate?.viewForZooming?(in: scrollView)
	}

	func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
		guard let scrollView = parent else { return }
		parent?.delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
	}

	func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		guard let scrollView = parent else { return }
		parent?.delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
	}


	func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
		guard let scrollView = self.parent else { return false }
		return parent?.delegate?.scrollViewShouldScrollToTop?(scrollView) ?? false
	}

	func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
		guard let scrollView = parent else { return }
		parent?.delegate?.scrollViewDidScrollToTop?(scrollView)
	}
}
