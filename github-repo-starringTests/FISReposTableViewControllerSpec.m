//
//  FISReposTableViewControllerSpec.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/8/14.
//  Copyright 2014 Joe Burgess. All rights reserved.
//

#import "Specta.h"
#import <KIF.h>
#define EXP_SHORTHAND
#import <Expecta.h>
#import "FISReposTableViewController.h"
#import "FISAppDelegate.h"


SpecBegin(FISReposTableViewController)

describe(@"FISReposTableViewController", ^{

    __block UITableView *tableView;
    __block UITableViewCell *secondCell;
    __block NSIndexPath *ip;
    beforeAll(^{
        tableView = (UITableView *)[tester waitForViewWithAccessibilityLabel:@"Repo Table View"];
        ip = [NSIndexPath indexPathForRow:1 inSection:0];
        secondCell = [tester waitForCellAtIndexPath:ip inTableViewWithAccessibilityIdentifier:@"Repo Table View"];
    });
    
    describe(@"TableVeiw", ^{
        it(@"Should have 1 section", ^{
            expect([tableView numberOfSections]).to.equal(1);
        });
        
        it(@"Should have two cells", ^{
            expect([tableView numberOfRowsInSection:0]).to.equal(2);
        });
    });

    describe(@"TableView Cells", ^{
        it(@"Should have a textLabel", ^{
            expect(secondCell.textLabel).toNot.beNil();
        });
        
        it(@"Should have the correct cells", ^{
            expect(secondCell.textLabel.text).to.equal(@"wycats/merb-core");
        });
    });

    describe(@"Starring/Unstarring Repos", ^{
        __block FISAppDelegate *delegate;

        beforeAll(^{
            delegate = [UIApplication sharedApplication].delegate;
        });
        it(@"Should star an unstarredRepo", ^{
            delegate.starred = NO;
            [tester tapRowAtIndexPath:ip inTableViewWithAccessibilityIdentifier:@"Repo Table View"];

            //This should be in a UIAlertView
            [tester waitForViewWithAccessibilityLabel:@"You just starred wycats/merb-core"];
            [tester tapViewWithAccessibilityLabel:@"OK"];
            [tester waitForAbsenceOfViewWithAccessibilityLabel:@"You just starred wycats/merb-core"];
        });

        it(@"Should unstar a starred Repo", ^{
            delegate.starred = YES;
            [tester tapRowAtIndexPath:ip inTableViewWithAccessibilityIdentifier:@"Repo Table View"];

            //This should be in a UIAlertView
            [tester waitForViewWithAccessibilityLabel:@"You just unstarred wycats/merb-core"];
            [tester tapViewWithAccessibilityLabel:@"OK"];
            [tester waitForAbsenceOfViewWithAccessibilityLabel:@"You just unstarred wycats/merb-core"];
        });
    });
    
});

SpecEnd
