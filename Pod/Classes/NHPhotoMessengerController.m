//
//  NHPhotoMessengerController.m
//  Pods
//
//  Created by Naithar on 30.04.15.
//
//

#import "NHPhotoMessengerController.h"
#import "NHPhotoCollectionViewCell.h"
#import "NHPhotoMessengerCollectionLayout.h"

const CGFloat kNHPhotoMessengerCollectionHeight = 75;

@interface NHPhotoMessengerController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, NHPhotoCollectionViewCellDelegate>

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
    self.attachmentButton.backgroundColor = [UIColor whiteColor];
    [self.attachmentButton setTitle:nil forState:UIControlStateNormal];
    [self.attachmentButton setImage:[UIImage imageNamed:@"NHmessenger.attachment"] forState:UIControlStateNormal];
    [self.leftView addSubview:self.attachmentButton withSize:CGSizeMake(35, 35) andIndex:0];

    self.photoCollectionView = [[UICollectionView alloc]
                                initWithFrame:CGRectZero
                                collectionViewLayout:[[NHPhotoMessengerCollectionLayout alloc] init]];

    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.photoCollectionView.alwaysBounceHorizontal = YES;
    self.photoCollectionView.showsVerticalScrollIndicator = NO;
    self.photoCollectionView.showsHorizontalScrollIndicator = NO;

    [self.photoCollectionView registerClass:[NHPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    [self.photoCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.photoCollectionView.backgroundColor = [UIColor whiteColor];

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

    [self.sendButton addTarget:self action:@selector(sendPhotosAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)sendPhotosAction:(UIButton*)button {

    __weak __typeof(self) weakSelf = self;
    if ([weakSelf.photoDelegate respondsToSelector:@selector(photoMessenger:didSendPhotos:)]) {
        [weakSelf.photoDelegate photoMessenger:weakSelf didSendPhotos:weakSelf.imageArray];
    }
}

- (BOOL)shouldShowSendButton {
    return [super shouldShowSendButton] || self.imageArray.count > 0;
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

    cell.backgroundColor = collectionView.backgroundColor;
    cell.delegate = self;

    return cell;
}

- (void)didTouchCloseButton:(UICollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.photoCollectionView indexPathForCell:cell];

    if (indexPath) {
        [self.imageArray removeObjectAtIndex:indexPath.row];
        [self.photoCollectionView deleteItemsAtIndexPaths:@[ indexPath ]];
    }

    if (self.imageArray.count == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.photoCollectionHeight.constant = 0;
            [self.bottomView.superview layoutIfNeeded];
        }];
    }

    [self updateSendButtonState];
}

- (void)clearImageArray {
    [self.imageArray removeAllObjects];
    [self.photoCollectionView reloadData];

    [UIView animateWithDuration:0.3 animations:^{
        self.photoCollectionHeight.constant = 0;
        [self.bottomView.superview layoutIfNeeded];
    }];

    [self updateSendButtonState];
}

- (void)addImageToCollection:(UIImage*)image {
    if (![self.imageArray count]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.photoCollectionHeight.constant = kNHPhotoMessengerCollectionHeight;
            [self.bottomView.superview layoutIfNeeded];
        }];
    }

    [self.imageArray addObject:image];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.imageArray.count - 1) inSection:0];
    [self.photoCollectionView insertItemsAtIndexPaths:@[ indexPath ]];

    [self.photoCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

    [self updateSendButtonState];
}

- (void)dealloc {
    [self.imageArray removeAllObjects];
}

@end
