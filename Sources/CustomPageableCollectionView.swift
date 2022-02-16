//
//  CustomPageableCollectionView.swift
//  CustomPageableCollectionView
//
//  Created by Andreas Verhoeven on 20/05/2021.
//

import UIKit

public class CustomPageableCollectionView: UICollectionView {
	private lazy var pager = PagerScrollView(parent: self)

	public var pagingConfiguration: PagingConfiguration {
		get { pager.configuration }
		set { pager.configuration = newValue }
	}
	
	public func scrollToPageForItem(with indexPath: IndexPath, animated: Bool) {
		guard let layoutAttributes = self.layoutAttributesForItem(at: indexPath) else { return }
		let offset = pagingConfiguration.pagedPagerContentOffset(for: layoutAttributes.frame, in: self, pager: pager)
		pager.setContentOffset(offset, animated: animated)
	}
	
	public var currentVerticalPageIndex: Int {
		return Int(pager.contentOffset.y / max(1, pager.bounds.height))
	}
	
	public var currentHorizontalPageIndex: Int {
		return Int(pager.contentOffset.x / max(1, pager.bounds.width))
	}

	// MARK: - Private
	private func setup() {
		pager.updateProperties()
	}

	// MARK: - UICollectionView
	public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		setup()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}

	// MARK: - UIScrollView
	private var _isPagingEnabled = true
	public override var isPagingEnabled: Bool {
		get { _isPagingEnabled }
		set {
			_isPagingEnabled = newValue
			pager.updateProperties()
		}
	}
	
	public override var isTracking: Bool {
		return pager.isTracking || super.isTracking
	}

	public override var isDragging: Bool {
		return pager.isDragging || super.isDragging
	}

	public override var isDecelerating: Bool {
		return pager.isDecelerating || super.isDecelerating
	}
	
	public override var delegate: UICollectionViewDelegate? {
		didSet { pager.updateProperties() }
	}

	public override var contentSize: CGSize {
		didSet {
			guard contentSize != oldValue else { return }
			pager.updateSize()
		}
	}
	
	public override var alwaysBounceVertical: Bool {
		didSet {
			guard alwaysBounceVertical != oldValue else { return }
			pager.updateProperties()
		}
	}
	
	public override var alwaysBounceHorizontal: Bool {
		didSet {
			guard alwaysBounceHorizontal != oldValue else { return }
			pager.updateProperties()
		}
	}
	
	public override func adjustedContentInsetDidChange() {
		super.adjustedContentInsetDidChange()
		pager.updateProperties()
	}
	
	public override var keyboardDismissMode: UIScrollView.KeyboardDismissMode {
		didSet {
			guard keyboardDismissMode != oldValue else { return }
			pager.updateProperties()
		}
	}
	
	public override var decelerationRate: UIScrollView.DecelerationRate {
		didSet {
			guard decelerationRate != oldValue else { return }
			pager.updateProperties()
		}
	}
	
	public override var isDirectionalLockEnabled: Bool {
		didSet {
			guard isDirectionalLockEnabled != oldValue else { return }
			pager.updateProperties()
		}
	}

	public override func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
		pager.scrollRectToVisible(rect, animated: animated)
	}

	public override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
		pager.setContentOffset(pagingConfiguration.pagerContentOffset(for: contentOffset, in: self, pager: pager), animated: animated)
	}

	public override var contentOffset: CGPoint {
		didSet {
			guard contentOffset != oldValue else { return }
			pager.updateForBoundsChange()
		}
	}

	// MARK: - UIView
	public override var bounds: CGRect {
		didSet { pager.updateForBoundsChange() }
	}
	
	public override var frame: CGRect {
		get { super.frame }
		set { pager.ignoreParentChanges { super.frame = newValue } }
	}
	
	public override func layoutSubviews() {
		pager.ignoreParentChanges { super.layoutSubviews() }
		pager.updateSize()
	}
}
