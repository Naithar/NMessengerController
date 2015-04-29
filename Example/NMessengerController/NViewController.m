//
//  NViewController.m
//  NMessengerController
//
//  Created by Naithar on 04/23/2015.
//  Copyright (c) 2014 Naithar. All rights reserved.
//

#import "NViewController.h"
#import <NHMessengerController.h>

@implementation NTextView

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, self.fakeContentSize.height);
}

@end

@interface NViewController ()<UITableViewDelegate, UITableViewDataSource>
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

    self.messengerController = [[NHMessengerController alloc] initWithScrollView:self.tableView andSuperview:self.view andTextInputClass:[NTextView class]];

    ((NTextView*)self.messengerController.textInputResponder).fakeContentSize = CGSizeMake(300, 100);
    self.messengerController.textViewInsets = UIEdgeInsetsMake(2, 15, 2, 15);
    self.messengerController.separatorInsets = UIEdgeInsetsMake(0, 15, 5, 15);
    self.messengerController.containerInsets = UIEdgeInsetsMake(5, 15, 5, 15);
	// Do any additional setup after loading the view, typically from a nib.
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

@end
