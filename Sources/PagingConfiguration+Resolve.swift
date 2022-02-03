//
//  PagingConfiguration+Resolve.swift
//  Demo
//
//  Created by Andreas Verhoeven on 21/05/2021.
//

import UIKit

extension PagingConfiguration {

	// MARK: - Pager Bounds
	func resolvedPagerBounds(for scrollView: UIScrollView, pager: UIScrollView) -> CGRect {
		let size = resolvedPageSize(for: scrollView)
		return CGRect(origin: pager.bounds.origin, size: size)
	}

	// MARK: - Pager ContentOffset
	func pagerContentOffset(for contentOffset: CGPoint, contentInsets: UIEdgeInsets, scrollView: UIScrollView) -> CGPoint {
		//let insets = resolvedPagingInsets(for: contentInsets)
		return resolvedContentOffset(for: contentOffset, viewSize: scrollView.bounds.size, contentInsets: scrollView.adjustedContentInset, isFromPagerToParent: false)
	}

	func pagerContentOffset(for contentOffset: CGPoint, in scrollView: UIScrollView, pager: UIScrollView) -> CGPoint {
		return pagerContentOffset(for: contentOffset, contentInsets: scrollView.adjustedContentInset, scrollView: scrollView)
	}
	
	func pagedPagerContentOffset(for frame: CGRect, in scrollView: UIScrollView, pager: UIScrollView) -> CGPoint {
		return pagedPagerContentOffset(for: frame, viewSize: scrollView.bounds.size, contentInsets: scrollView.adjustedContentInset)
	}
	
	func pagedPagerContentOffset(for frame: CGRect, viewSize: CGSize, contentInsets: UIEdgeInsets) -> CGPoint {
		var output = CGPoint.zero
		let pageSize = resolvedPageSize(for: viewSize, contentInsets: contentInsets)
		
		if size.height.isUnused == false {
			output.y = (frame.minY / ceil(max(1, pageSize.height))) * pageSize.height
		}
		
		if size.width.isUnused == false {
			output.x = (frame.minX / ceil(max(1, pageSize.width))) * pageSize.width
		}
		
		return output
	}

	// MARK: - ResolvedContentOffset
	func resolvedContentOffset(for scrollView: UIScrollView, pager: UIScrollView) -> CGPoint {
		return resolvedContentOffset(for: pager.contentOffset, viewSize: scrollView.bounds.size, contentInsets: scrollView.adjustedContentInset, isFromPagerToParent: true)
	}

	func resolvedContentOffset(for contentOffset: CGPoint, viewSize: CGSize, contentInsets: UIEdgeInsets, isFromPagerToParent: Bool) -> CGPoint {
		let insets = resolvedPagingInsets(for: contentInsets)
		let factor = CGFloat(isFromPagerToParent == true ? 1 : -1)

		var output = contentOffset
		if size.height.isUnused == false {
			switch alignment.vertical {
				case .top:
					output.y -= (insets.top + positionInsets.top) * factor

				case .center:
					let pageSize = resolvedPageSize(for: viewSize, contentInsets: contentInsets)
					let center = insets.top + (viewSize.height - insets.top - insets.bottom) * 0.5
					output.y += (-center + pageSize.height * 0.5 - positionInsets.top + positionInsets.bottom) * factor


				case .bottom:
					let pageSize = resolvedPageSize(for: viewSize, contentInsets: contentInsets)
					output.y += (-viewSize.height + pageSize.height + insets.bottom + positionInsets.bottom) * factor
			}
		}

		if size.width.isUnused == false {
			switch alignment.horizontal {
				case .leading:
					output.x -= (insets.left + positionInsets.left)

				case .center:
					let pageSize = resolvedPageSize(for: viewSize, contentInsets: contentInsets)
					let center = insets.left + (viewSize.width - insets.left - insets.right) * 0.5
					output.x += (-center + pageSize.width * 0.5 - positionInsets.left + positionInsets.right) * factor


				case .trailing:
					let pageSize = resolvedPageSize(for: viewSize, contentInsets: contentInsets)
					output.x += (-viewSize.width + pageSize.width + insets.right + positionInsets.right) * factor
			}
		}
		return output
	}

	// MARK: - PageSize
	func resolvedPageSize(for scrollView: UIScrollView) -> CGSize {
		return resolvedPageSize(for: scrollView.bounds.size, contentInsets: scrollView.adjustedContentInset)
	}

	func resolvedPageSize(for viewSize: CGSize, contentInsets: UIEdgeInsets) -> CGSize {
		let insets = resolvedPagingInsets(for: contentInsets)
		return CGSize(width: size.width.resolve(max(0, viewSize.width - insets.left - insets.right)),
					  height: size.height.resolve(max(0, viewSize.height - insets.top - insets.bottom)))
	}

	// MARK: - PageInsets
	func resolvedPagingInsets(for insets: UIEdgeInsets) -> UIEdgeInsets {
		return UIEdgeInsets(
			top: sizeInsets.top + (contentInsetEdgesToUse.contains(.top) ? insets.top : 0),
			left: sizeInsets.left + (contentInsetEdgesToUse.contains(.left) ? insets.left : 0),
			bottom: sizeInsets.bottom + (contentInsetEdgesToUse.contains(.bottom) ? insets.bottom : 0),
			right: sizeInsets.right + (contentInsetEdgesToUse.contains(.right) ? insets.right : 0))
	}
}

extension PagingConfiguration.Size.Dimension {
	func resolve(_ value: CGFloat) -> CGFloat {
		switch self {
			case .unused: return value
			case .absolute(let fixedValue): return fixedValue
			case .fractional(let ratio): return ratio * value
		}
	}

	var isUnused: Bool {
		switch self {
			case .unused: return true
			case .absolute: return false
			case .fractional: return false
		}
	}
}
