//
//  NViewController.m
//  NMessengerController
//
//  Created by Naithar on 04/23/2015.
//  Copyright (c) 2014 Naithar. All rights reserved.
//

#import "NViewController.h"
#import <NMessengerController.h>
#import <NHTextView.h>

@implementation NTextView

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, self.fakeContentSize.height);
}

@end

@interface NViewController ()<UITableViewDelegate, UITableViewDataSource, NHMessengerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NHPhotoMessengerController *messengerController;
@end

@implementation NViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    self.messengerController = [[NHPhotoMessengerController alloc] initWithScrollView:self.tableView andSuperview:self.view andTextInputClass:[NHTextView class]];

    ((NHTextView*)self.messengerController.textInputResponder).placeholder = @"placeholder";
    ((NHTextView*)self.messengerController.textInputResponder).findMentions = YES;
    ((NHTextView*)self.messengerController.textInputResponder).numberOfLines = 4;
    ((NHTextView*)self.messengerController.textInputResponder).useHeightConstraint = YES;
    ((NHTextView*)self.messengerController.textInputResponder).isGrowingTextView = YES;

    self.messengerController.delegate = self;

    ((NTextView*)self.messengerController.textInputResponder).text = @"dsadas";


    UIView *tv = [UIView new];
    tv.backgroundColor = [UIColor brownColor];
    [tv setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.messengerController.topView addSubview:tv];


    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:tv
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual toItem:tv
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:0
                                                               constant:300];
    height.priority = 750;
    [tv addConstraint:height];

    [self.messengerController.topView addConstraint:[NSLayoutConstraint
                                                     constraintWithItem:tv
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:self.messengerController.topView
                                                     attribute:NSLayoutAttributeTop
                                                     multiplier:1.0 constant:0]];

    [self.messengerController.topView addConstraint:[NSLayoutConstraint
                                                     constraintWithItem:tv
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:self.messengerController.topView
                                                     attribute:NSLayoutAttributeLeft
                                                     multiplier:1.0 constant:0]];

    [self.messengerController.topView addConstraint:[NSLayoutConstraint
                                                     constraintWithItem:tv
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:self.messengerController.topView
                                                     attribute:NSLayoutAttributeRight
                                                     multiplier:1.0 constant:0]];

    [self.messengerController.topView addConstraint:[NSLayoutConstraint
                                                     constraintWithItem:tv
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:self.messengerController.topView
                                                     attribute:NSLayoutAttributeBottom
                                                     multiplier:1.0 constant:0]];

//    [self.messengerController.topView invalidateIntrinsicContentSize];
//    [self.view layoutIfNeeded];
    [self.messengerController updateMessengerView];

    [self.messengerController.attachmentButton addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
//    for (int i = 0; i < 10; i++) {
//        [self.messengerController addImageToCollection:[NSNull null]];
//    }
}

- (void)addPhoto:(UIButton*)button {
    [self.messengerController addImageToCollection:[NSNull null]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];

    return cell;
}

- (void)messenger:(NHMessengerController *)messenger didSendText:(NSString *)text {
    NSLog(@"send text = %@", text);
}

- (void)messenger:(NHMessengerController *)messenger didChangeText:(NSString *)text {
    NSLog(@"change text = %@", text);
}

- (void)messenger:(NHMessengerController *)messenger didChangeButtonHiddenTo:(BOOL)isHidden {
    NSLog(@"hide button = %d", isHidden);
}

- (void)willShowKeyboardForMessenger:(NHMessengerController *)messenger {
    NSLog(@"show");
}

- (void)willHideKeyboardForMessenger:(NHMessengerController *)messenger {
    NSLog(@"hide");
}

- (void)didStartEditingInMessenger:(NHMessengerController *)messenger {
    NSLog(@"edit");
    [[self messengerController] scrollToBottomAnimated:YES];
}

@end
