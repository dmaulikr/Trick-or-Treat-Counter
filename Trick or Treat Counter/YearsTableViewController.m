//
//  YearsTableViewController.m
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 11/22/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "YearsTableViewController.h"

@implementation YearsTableViewController


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(UITableView *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *simpleIdentifier = @"simpleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: simpleIdentifier];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
