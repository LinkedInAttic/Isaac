// © 2014 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "MainViewController.h"

// JSON Parsing
#import "NSObject+IssacJSONToObject.h"
// Models
#import "LargeJSONModel.h"
#import "PerformanceFriendModel.h"
#import "PerformancePersonModel.h"
#import "PerformanceFriendRecursiveModel.h"


@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

// Key is the json file name, value is the class it should be parsed into
@property (nonatomic, readonly) NSArray *dataSet;

@property (nonatomic, weak) IBOutlet UILabel *numberOfTriesLabel;

@property (nonatomic) NSUInteger numberOfTries;

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  self.title = @"Performance";
  
  self.numberOfTries = 5;
  self.numberOfTriesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.numberOfTries];
}

- (IBAction)numberOfTriesChanged:(UISlider *)sender {
  self.numberOfTries = sender.value;
  self.numberOfTriesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.numberOfTries];
}

#pragma mark - Data

- (NSArray *)dataSet {
  return @[
           @{@"file": @"NormalJSON", @"class": [LargeJSONModel class]},
           @{@"file": @"VeryLargeJSON", @"class": [LargeJSONModel class]},
           @{@"file": @"LargeDeepJSON", @"class": [PerformanceFriendModel class]},
           @{@"file": @"SmallVeryDeepJSON", @"class": [PerformanceFriendRecursiveModel class]}
           ];
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSDictionary *info = self.dataSet[indexPath.row];
  NSString *fileName = info[@"file"];
  Class class = info[@"class"];
  
  // Get the file
  NSString* fileRoot = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"json"];
  
  NSError *error = nil;
  NSData *data = [NSData dataWithContentsOfFile:fileRoot
                                        options:0
                                          error:&error];
  if (error) {
    NSLog(@"Error: %@", error);
  }
  
  NSMutableArray *jsonTimes = [NSMutableArray array];
  NSMutableArray *modelTimes = [NSMutableArray array];
  NSMutableArray *setupWithData = [NSMutableArray array];
  
  for (int i = 0; i<self.numberOfTries; i++) {
    // Time the JSON Parsing
    NSDate *now = [NSDate date];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:&error];
    if (error) {
      NSLog(@"Error: %@", error);
    }
    
    NSTimeInterval interval = -[now timeIntervalSinceNow];
    
    [jsonTimes addObject:@(interval)];
    
    // Time the model parsing
    now = [NSDate date];
    
    [json isc_objectFromJSONWithClass:class];
    
    NSTimeInterval secondInterval = -[now timeIntervalSinceNow];
    
    [modelTimes addObject:@(secondInterval)];
    
    // Time the model parsing using setupWithData (old way of setting up models)
    now = [NSDate date];
    
    id model = [[class alloc] init];
    [model setupWithData:json];
    
    NSTimeInterval thirdInterval = -[now timeIntervalSinceNow];
    
    [setupWithData addObject:@(thirdInterval)];
  }
  
  NSString *resultText = [NSString stringWithFormat:@"JSON Average: %f\nModel Average: %f\nsetupWithData Average: %f\n\nJSON Times: %@\nModel Times: %@\nsetupWithData Times: %@\n\nRan the simulation %ld times",
                          [self averageForArray:jsonTimes],
                          [self averageForArray:modelTimes],
                          [self averageForArray:setupWithData],
                          jsonTimes,
                          modelTimes,
                          setupWithData,
                          (unsigned long)self.numberOfTries];
  [[[UIAlertView alloc] initWithTitle:@"Results"
                              message:resultText
                             delegate:nil
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil] show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.dataSet count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  NSString *title = self.dataSet[indexPath.row][@"file"];
  
  // Get the file
  NSString* fileRoot = [[NSBundle bundleForClass:[self class]] pathForResource:title ofType:@"json"];
  NSError *error = nil;
  NSData *data = [NSData dataWithContentsOfFile:fileRoot
                                        options:0
                                          error:&error];
  
  cell.textLabel.text = [NSString stringWithFormat:@"%@ (%u KB)", title, [data length] / 1024];
  return cell;
}

#pragma mark - Helpers

- (double)averageForArray:(NSArray *)array {
  double total = 0;
  for (NSNumber *number in array) {
    double value = [number doubleValue];
    NSAssert(value >= 0, @"We shouldn't have negative values here");
    total += value;
  }
  return total / [array count];
}

@end
