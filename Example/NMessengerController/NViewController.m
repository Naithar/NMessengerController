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

@interface NViewController ()<UITableViewDelegate, UITableViewDataSource, NHMessengerControllerDelegate, NHPhotoMessengerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NHPhotoMessengerController *messengerController;

//@property (strong, nonatomic) UIView *accessory;

@end

@implementation NViewController

//- (BOOL)becomeFirstResponder {
//    return [super becomeFirstResponder];
//}
//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}
//- (UIView *)inputAccessoryView {
//    return self.accessory;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.accessory = [UIView new];
    
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
    self.messengerController.photoDelegate = self;

    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, self.messengerController.sendButtonSize.height)];
    v1.backgroundColor = [UIColor redColor];
    self.messengerController.sendButtonInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    [self.messengerController.rightView addSubview:v1 andIndex:0];

    [self.messengerController updateMessengerView];


    ((NTextView*)self.messengerController.textInputResponder).text = @"dsadas";

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


- (void)messenger:(NHMessengerController *)messenger willChangeMessengerInset:(UIEdgeInsets)insets {
    NSLog(@"%@", NSStringFromUIEdgeInsets(insets));
}

-(void)messenger:(NHMessengerController *)messenger willChangeKeyboardInset:(UIEdgeInsets)insets {
    NSLog(@"%@", NSStringFromUIEdgeInsets(insets));
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

- (void)photoMessenger:(NHPhotoMessengerController *)messenger didSendPhotos:(NSArray *)array {
    NSLog(@"sending text %@\nphotos = %@", [messenger.textInputResponder text], array);



    [messenger.textInputResponder setText:nil];
    [messenger clearImageArray];
}

@end
