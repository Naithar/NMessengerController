//
//  NHPhotoMessengerCollectionLayout.m
//  Pods
//
//  Created by Naithar on 30.04.15.
//
//

#import "NHPhotoMessengerCollectionLayout.h"

@implementation NHPhotoMessengerCollectionLayout

- (instancetype)init {
    self = [super init];

    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }

    return self;
}

//- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//
//    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
//    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
//
//    return attr;
//}

//- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//
//    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
//    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
//
//    return attr;
//}
@end
