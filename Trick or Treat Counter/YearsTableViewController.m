//
//  YearsTableViewController.m
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 11/22/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "YearsTableViewController.h"

@interface YearsTableViewController ()

@property (nonatomic) NSMutableArray *years;

@end

@implementation YearsTableViewController


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    CoreDataFunctions* coredataObject = [[CoreDataFunctions alloc] init];
    User *currentUser = [coredataObject performFetch];
    
    NSSet *yearsSet = [currentUser valueForKey:@"years"];
    
    _years = [[NSMutableArray alloc] init];
    
    for (Year *i in yearsSet) {
        
        [_years addObject:i];
        
    }
    
    return _years.count;
}

-(UITableView *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *simpleIdentifier = @"simpleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: simpleIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
    }

    Year *singleYear = _years[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@,   The Number of Visitors: %hd", singleYear.year, singleYear.visitors];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    
}


@end
