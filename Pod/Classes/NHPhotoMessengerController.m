//
//  NHPhotoMessengerController.m
//  Pods
//
//  Created by Naithar on 30.04.15.
//
//

#import "NHPhotoMessengerController.h"
#import "NHPhotoCollectionViewCell.h"

const CGFloat kNHPhotoMessengerCollectionHeight = 75;

@interface NHPhotoMessengerController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *attachmentButton;
@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSLayoutConstraint *photoCollectionHeight;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation NHPhotoMessengerController

- (instancetype)initWithScrollView:(UIScrollView *)scrollView andSuperview:(UIView *)superview andTextInputClass:(Class)textInputClass {
    self = [super initWithScrollView:scrollView andSuperview:superview andTextInputClass:textInputClass];

    if (self) {
        [self photoMessegerInit];
    }
    return self;
}

- (void)photoMessegerInit {
    _imageArray = [@[] mutableCopy];

    self.attachmentButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.attachmentButton.backgroundColor = [UIColor greenColor];
    [self.leftView addSubview:self.attachmentButton withSize:CGSizeMake(35, 35) andIndex:0];


    self.photoCollectionView = [[UICollectionView alloc]
                                initWithFrame:CGRectZero
                                collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];

    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    ((UICollectionViewFlowLayout*)self.photoCollectionView.collectionViewLayout).scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.photoCollectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);

    [self.photoCollectionView registerClass:[NHPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    [self.photoCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.photoCollectionView.backgroundColor = [UIColor brownColor];

    [self.bottomView addSubview:self.photoCollectionView];

    self.photoCollectionHeight = [NSLayoutConstraint constraintWithItem:self.photoCollectionView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.photoCollectionView
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:0
                                                               constant:0];

    [self.photoCollectionView addConstraint:self.photoCollectionHeight];

    [self.bottomView addConstraint:[NSLayoutConstraint constraintWithItem:self.photoCollectionView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.bottomView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0 constant:0]];

    [self.bottomView addConstraint:[NSLayoutConstraint constraintWithItem:self.photoCollectionView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.bottomView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0 constant:0]];

    [self.bottomView addConstraint:[NSLayoutConstraint constraintWithItem:self.photoCollectionView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.bottomView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0 constant:0]];

    [self.bottomView addConstraint:[NSLayoutConstraint constraintWithItem:self.photoCollectionView
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.bottomView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0 constant:0]];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.imageArray count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kNHPhotoMessengerCollectionHeight - 5, kNHPhotoMessengerCollectionHeight - 5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NHPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                           forIndexPath:indexPath];

    cell.backgroundColor = [UIColor whiteColor];

    return cell;
}

- (void)addImageToCollection:(UIImage*)image {
    if (![self.imageArray count]) {
        self.photoCollectionHeight.constant = kNHPhotoMessengerCollectionHeight;
    }

    [self.imageArray addObject:image];

    [self.photoCollectionView reloadData];
}

@end
