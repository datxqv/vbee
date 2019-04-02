//
//  CollectionViewExtension.swift
//  LaleTore
//
//  Created by luckymanbk on 11/24/16.
//  Copyright © 2016 Paditech. All rights reserved.
//

import UIKit

public let kTagLabel = 9999999
public let kTagIndicator = 99999999

extension UICollectionView {
    
    func addIndicator(style: UIActivityIndicatorViewStyle) {
        if self.viewWithTag(kTagIndicator) == nil {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: style)
            indicator.tag = kTagIndicator
            indicator.center = self.center
            self.addSubview(indicator)
            indicator.startAnimating()
        }
    }
    
    func removeIndicator() {
        self.subviews.forEach {
            $0.viewWithTag(kTagIndicator)?.removeFromSuperview()
        }
    }
    
//    func addLabel(_ title: String) {
//        if self.viewWithTag(kTagLabel) == nil {
//            let font = UIFont.systemFont(ofSize: 14)//FontsHelper.fontHelvetica(ofSize: 14)
//            let height = title.stringHeightWithMaxWidth(self.width, font: font)
//            let label = ECusstomLabel(frame: CGRect(x: 15, y: 20, width: UIScreen.width - 30, height: height + 40))
//            label.tag = kTagLabel
//            label.backgroundColor = UIColor.clear
//            label.textColor = UIColor.gray
//            label.text = title
//            label.font = font
//            label.numberOfLines = 0
//            label.textAlignment = .center
//            self.addSubview(label)
//        }
//    }
    
    func removeLabel() {
        self.subviews.forEach {
            $0.viewWithTag(kTagLabel)?.removeFromSuperview()
        }
    }
}

open class LGHorizontalLinearFlowLayout: UICollectionViewFlowLayout {
    
    fileprivate var lastCollectionViewSize: CGSize = CGSize.zero
    open var scalingOffset: CGFloat = 100
    open var minimumScaleFactor: CGFloat = 0.92
    open var scaleItems: Bool = true
    
    static func configureLayout(_ collectionView: UICollectionView, itemSize: CGSize, minimumLineSpacing: CGFloat) -> LGHorizontalLinearFlowLayout {
        
        let layout = LGHorizontalLinearFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        layout.itemSize = itemSize
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.collectionViewLayout = layout
        
        return layout
    }
    
    override open func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        
        if self.collectionView == nil {
            return
        }
        
        let currentCollectionViewSize = self.collectionView!.bounds.size
        
        if !currentCollectionViewSize.equalTo(self.lastCollectionViewSize) {
            self.configureInset()
            self.lastCollectionViewSize = currentCollectionViewSize
        }
    }
    
    fileprivate func configureInset() -> Void {
        if self.collectionView == nil {
            return
        }
        
        let inset = self.collectionView!.bounds.size.width / 2 - self.itemSize.width / 2
        self.collectionView!.contentInset = UIEdgeInsetsMake(0, inset, 0, inset)
        self.collectionView!.contentOffset = CGPoint(x: -inset, y: 0)
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if self.collectionView == nil {
            return proposedContentOffset
        }
        
        let collectionViewSize = self.collectionView!.bounds.size
        let proposedRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionViewSize.width, height: collectionViewSize.height)
        
        let layoutAttributes = self.layoutAttributesForElements(in: proposedRect)
        
        if layoutAttributes == nil {
            return proposedContentOffset
        }
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width / 2
        
        for attributes: UICollectionViewLayoutAttributes in layoutAttributes! {
            if attributes.representedElementCategory != .cell {
                continue
            }
            
            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }
            
            if fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                candidateAttributes = attributes
            }
        }
        
        if candidateAttributes == nil {
            return proposedContentOffset
        }
        
        var newOffsetX = candidateAttributes!.center.x - self.collectionView!.bounds.size.width / 2
        
        let offset = newOffsetX - self.collectionView!.contentOffset.x
        
        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            let pageWidth = self.itemSize.width + self.minimumLineSpacing
            newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
        }
        
        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if !self.scaleItems || self.collectionView == nil {
            return super.layoutAttributesForElements(in: rect)
        }
        
        let superAttributes = super.layoutAttributesForElements(in: rect)
        
        if superAttributes == nil {
            return nil
        }
        
        let contentOffset = self.collectionView!.contentOffset
        let size = self.collectionView!.bounds.size
        
        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
        let visibleCenterX = visibleRect.midX
        
        var newAttributesArray = Array<UICollectionViewLayoutAttributes>()
        for (_, attributes) in superAttributes!.enumerated() {
            let newAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            newAttributesArray.append(newAttributes)
            let distanceFromCenter = visibleCenterX - newAttributes.center.x
            let absDistanceFromCenter = min(abs(distanceFromCenter), self.scalingOffset)
            let scale = absDistanceFromCenter * (self.minimumScaleFactor - 1) / self.scalingOffset + 1
            newAttributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
            
        }
        
        return newAttributesArray;
    }
    
}
