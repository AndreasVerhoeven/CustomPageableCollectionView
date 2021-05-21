# CustomPageableCollectionView
A pageable collection/table/scroll view that can use any page size and still uses the standard iOS paging

# What?

`UIScrollView`'s `isPagingEnabled` only works well if your pages are exactly the full size of the scrollview it self. Often, however, you're dealing with insets or you simply want smaller pages.

A lot of solutions override `scrollViewDidEndDraggingWithVelocity` and try to replicate the paging that iOS does, but most of them don't take quick swipes into account.

This small library provides 3 subclasses that allows you to tweak the paging exactly like you wish: you can set the page size, paging edge, insets, and more. 

The subclasses are:

- `CustomPageableScrollView`
- `CustomPageableTableView`
- `CustomPageableCollectionView`

# Usage

Each of those 3 subclasses has `isPagingEnabled` set to `true` by default and each of them has  `pagingConfiguration` property. This property determines how paging is done.

You can configure the following:

- `size` , sets the size of the pages for both axis, either an absolute value or relative to the visible area
- `alignment` sets to which edges the pages are aligned on both axis.
- `contentInsetEdgesToUse` by default, the paging algorithm takes all `adjustedContentInsets` of the scroll view into account, this allows you to ignore certain insets.
- `positionInsets` this allows you to inset the position of the page alignment even further. For example, you can make the page stop 100 pts of the left boundary by setting: `.left = 100`
- `sizeInsets` this is used when calculating relative page sizes by applying extra insets to the visible area.

Example:

This pages a collection view 100 points at a time and aligns the page 100 pts to the right of the leading edge
```
collectionView.pagingConfiguration.size = .absolute(width: 100)
collectionView.pagingConfiguration.alignment = .leading
collectionView.pagingConfiguration.positionInsets.left = 100
```

This pages a collection view vertically where the page size is 50% of the visible area and centers the pages vertically:
```
collectionView.pagingConfiguration.size = .fractional(height: 0.5)
collectionView.pagingConfiguration.alignment = .centerY
```

This pages a collection view vertically where the page size is 50% of the visible area, minus 20 points inset and aligns the bottom of the page with the bottom of the collection view:
```
collectionView.pagingConfiguration.size = .fractional(height: 0.5)
collectionView.pagingConfiguration.sizeInsets.top = 10
collectionView.pagingConfiguration.sizeInsets.bottom = 10
collectionView.pagingConfiguration.alignment = .bottom
```

# Limitations
 - ScrollView indicators will not be visible
 - scrollsToTop gesture won't work
 
 # How does it work?
 
 This library works by creating a second, hidden, scroll view (the "pager") that has the same size as the page size and the same contentSize as the actual scroll view and has `isPagingEnabled`.
 
 Because our pager has the same size as our pages, when we scroll in the pager,  we'll get the exact paging behavior that iOS uses and what we expect. 

Then, the `panGestureRecognizer` of our pager is added to the actual scroll view, so that when you pan and swipe in the actual scroll view, we actually scroll the pager.

Finally, we sync the `contentOffset` (with some extra offsets for alignment) of our pager with the actual scroll view.
