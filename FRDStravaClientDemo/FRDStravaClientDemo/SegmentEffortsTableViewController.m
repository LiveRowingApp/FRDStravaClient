//
//  SegmentEffortsTableViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/10/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "SegmentEffortsTableViewController.h"
#import "FRDStravaClient+Segment.h"

@interface SegmentEffortsTableViewController ()

@property (nonatomic, strong) NSArray *efforts;
@property (nonatomic) int pageIndex;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation SegmentEffortsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self showNextPage];
}

-(void) showNextPage
{
    [self showSpinner];
    
    [[FRDStravaClient sharedInstance] fetchSegmentEffortsForSegment:self.segmentId
                                                           pageSize:10
                                                          pageIndex:self.pageIndex
                                                            success:^(NSArray *efforts) {
                                                                [self hideSpinner];
                                                                self.efforts = efforts;
                                                                
                                                                [self.tableView reloadData];
                                                                self.pageIndex ++;
                                                            }
                                                            failure:^(NSError *error) {
                                                                [self hideSpinner];
                                                                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"FAIL"
                                                                                                             message:error.localizedDescription
                                                                                                            delegate:nil
                                                                                                   cancelButtonTitle:@"Close" otherButtonTitles: nil];
                                                                [av show];
                                                            }];

}

-(void) showSpinner
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

-(void) hideSpinner
{
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithTitle:@"more"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(showNextPage)];
    self.navigationItem.rightBarButtonItem = moreButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.efforts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentEffortCell"
                                                            forIndexPath:indexPath];
    
    StravaSegmentEffort *effort = self.efforts[indexPath.row];
    cell.textLabel.text = [self.dateFormatter stringFromDate:effort.startDate];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Athlete: %ld, duration:%f sec", (long) effort.athleteId, effort.elapsedTime];
    
    return cell;
}


@end