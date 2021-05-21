//
//  PagingConfiguration.swift
//  CustomPageableCollectionView
//
//  Created by Andreas Verhoeven on 20/05/2021.
//

import UIKit

public struct PagingConfiguration: Equatable {
	/// The size of each "page" when paging
	public var size: Size = .full

	/// the alignment to use when aligning a "page"
	public var alignment = Alignment()

	/// The contentInset edges of the scroll view to use
	/// when calculating the paging position.
	/// For example, when you want to ignore the top inset
	/// (and safeArea), you can `remove(.top)` and the top
	/// inset will be ignored for positions
	public var contentInsetEdgesToUse: UIRectEdge = .all

	/// Extra insets to use when calculating the position of each
	/// page stop. For example, if you want to have each page
	/// stop be 100 points of the top, you use
	/// `UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)`
	public var positionInsets: UIEdgeInsets = .zero

	/// Extra insets to use when calculating the size of the pages,
	/// if applicable. If you use a fractional page size, this will
	/// be used to modify the full size.
	/// For example, if the horizontal area is 812 points, but you want
	/// the pages to be smaller, you can set this to
	/// `UIEdgeInsets(top: 50, left: 0, bottom: 500, right: 0)`
	public var sizeInsets: UIEdgeInsets = .zero
}

public extension PagingConfiguration {
	/// Alignment for both axis
	struct Alignment: Equatable {
		/// vertical alignment
		public var vertical: VerticalAlignment = .top

		/// horizontal page alignment
		public var horizontal: HorizontalAlignment = .leading

		/// aligns pages to top, taking all inset configuration into account
		public static var top: Self { Self(vertical: .top, horizontal: .leading) }

		/// centers pages vertically, taking all inset configuration into account
		public static var centerY: Self { Self(vertical: .center, horizontal: .leading) }

		/// aligns pages to the bottom, taking all inset configuration into account
		public static var bottom: Self { Self(vertical: .bottom, horizontal: .leading) }

		/// aligns pages to the leading edge, taking all inset configuration into account
		public static var leading: Self { Self(vertical: .top, horizontal: .leading) }

		/// centers pages horizontally, taking all inset configuration into account
		public static var centerX: Self { Self(vertical: .top, horizontal: .center) }

		/// aligns pages to the leading edge, taking all inset configuration into account
		public static var trailing: Self { Self(vertical: .top, horizontal: .trailing) }
	}
}

public extension PagingConfiguration.Alignment {
	enum VerticalAlignment: Equatable {
		case top
		case center
		case bottom
	}

	enum HorizontalAlignment: Equatable {
		case leading
		case center
		case trailing
	}
}


public extension PagingConfiguration {
	struct Size: Equatable {
		/// The width of the dme
		public var width: Dimension = .unused
		public var height: Dimension = .unused

		/// pages have an absolute width
		public static func absolute(width: CGFloat) -> Self {
			return Self(width: .absolute(width))
		}

		/// pages have an absolute height
		public static func absolute(height: CGFloat) -> Self {
			return Self(height: .absolute(height))
		}

		/// pages have a fractional width of the scrollable area, minus all the configured insets
		public static func fractional(width: CGFloat) -> Self {
			return Self(width: .fractional(width))
		}

		/// pages have a fractional height of the scrollable area, minus all the configured insets
		public static func fractional(height: CGFloat) -> Self {
			return Self(height: .fractional(height))
		}

		/// convenience for fractional(width: 1)
		public static var fullWidth: Self {
			return fractional(width: 1)
		}

		/// convenience for fractional(height: 1)
		public static var fullHeight: Self {
			return fractional(height: 1)
		}

		/// convenience for fractional(width: 1, height: 1)
		public static var full: Self {
			return Self(width: .fractional(1), height: .fractional(1))
		}
	}
}

public extension PagingConfiguration.Size {
	enum Dimension: Equatable {
		/// this dimension is unused when paging
		case unused

		/// this dimension is an absolute value
		case absolute(_ value: CGFloat)

		/// this dimension depends on the visible
		/// scrollable are and the sizeInsets.
		/// A value of `1` corresponds to
		/// a full "visible" page.
		case fractional(_ ratio: CGFloat)
	}
}
