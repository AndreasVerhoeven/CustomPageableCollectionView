//
//  CustomPageableTableView.swift
//  CustomPageableCollectionView
//
//  Created by Andreas Verhoeven on 21/05/2021.
//

import UIKit

public class CustomPageableTableView: UITableView {
	private lazy var pager = PagerScrollView(parent: self)

	public var pagingConfiguration: PagingConfiguration {
		get { pager.configuration }
		set { pager.configuration = newValue }
	}
	
	public func scrollToPageOfRow(with indexPath: IndexPath, animated: Bool) {
		let offset = pagingConfiguration.pagedPagerContentOffset(for: self.rectForRow(at: indexPath), in: self, pager: pager)
		pager.setContentOffset(offset, animated: animated)
	}
	
	public var currentPageIndex: Int {
		return Int(pager.contentOffset.y / max(1, pager.bounds.height))
	}

	// MARK: - Private
	private func setup() {
		pager.updateProperties()
	}

	// MARK: - UICollectionView
	public override init(frame: CGRect, style: UITableView.Style) {
		super.init(frame: frame, style: style)
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

	public override var delegate: UITableViewDelegate? {
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
			pager.contentOffset = pagingConfiguration.pagerContentOffset(for: contentOffset, in: self, pager: pager)
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

