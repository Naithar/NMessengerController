//
//  NViewController.m
//  NMessengerController
//
//  Created by Naithar on 04/23/2015.
//  Copyright (c) 2014 Naithar. All rights reserved.
//

#import "NViewController.h"
#import <NHMessengerController.h>
#import <NHTextView.h>

@implementation NTextView

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, self.fakeContentSize.height);
}

@end

@interface NViewController ()<UITableViewDelegate, UITableViewDataSource, NHMessengerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NHMessengerController *messengerController;
@end

@implementation NViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    self.messengerController = [[NHMessengerController alloc] initWithScrollView:self.tableView andSuperview:self.view andTextInputClass:[NHTextView class]];

    ((NHTextView*)self.messengerController.textInputResponder).numberOfLines = 4;
    ((NHTextView*)self.messengerController.textInputResponder).useHeightConstraint = YES;
    ((NHTextView*)self.messengerController.textInputResponder).isGrowingTextView = YES;

    self.messengerController.delegate = self;

    ((NTextView*)self.messengerController.textInputResponder).text = @"dsadas";

    UIView *v = [UIView new];
    v.backgroundColor = [UIColor brownColor];
    [self.messengerController.leftView addSubview:v withSize:CGSizeMake(35, 35) andIndex:0];

    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor grayColor];
    [self.messengerController.leftView addSubview:v1 withSize:CGSizeMake(35, 35) andIndex:1];

    [self.messengerController updateMessengerView];

    self.messengerController.topView.contentSize = CGSizeMake(0, 300);
    self.messengerController.bottomView.contentSize = CGSizeMake(0, 50);
//    [self.messengerController.topView invalidateIntrinsicContentSize];
//    [self.view layoutIfNeeded];
    [self.messengerController updateMessengerView];
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
}

@end
