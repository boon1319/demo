//
//  ViewController.m
//  JSONExample
//
//  Created by Unbounded Solutions on 4/30/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import "ViewController.h"

#define loansURL [NSURL URLWithString: @"http://api.kivaws.org/v1/loans/search.json?status=fundraising"]
#define mainQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    dispatch_async(mainQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:loansURL];
        
        [self performSelectorOnMainThread:@selector(dataRetreived:) withObject:data waitUntilDone:YES];
    });
    
    NSLog(@"%@", @"try to make a first change");
    
    NSLog(@"%@", @"try to sync from sourcetree");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataRetreived:(NSData*)dataResponse
{
    NSError *error;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:dataResponse options:0 error:&error];
    
    NSArray *loanArray = [jsonResponse objectForKey:@"loans"];
    
    NSDictionary *currentLoan = [loanArray objectAtIndex:0];
    
    NSNumber *fundedamount = [currentLoan objectForKey:@"funded_amount"];
    NSNumber *loanamount = [currentLoan objectForKey:@"loan_amount"];
    
    NSString *customerName = [currentLoan objectForKey:@"name"];

    NSString *location = [(NSDictionary*)[currentLoan objectForKey:@"location"] objectForKey:@"country"];
    
    float outstandindAmount = [loanamount floatValue] - [fundedamount floatValue];
    
    self.displayLabel.text = [NSString stringWithFormat:@"Latest Loan: %@ from %@ needs $%.2f to reach their goal", customerName, location, outstandindAmount];
}

@end
