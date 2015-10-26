//
//  iTunesSearchTests.m
//  iTunesSearchTests
//
//  Created by rozh.surchi on 22/12/2014.
//  Copyright (c) 2014 rozh.surchi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ISNetworkManager.h"

@interface iTunesSearchTests : XCTestCase
@property (nonatomic) ISNetworkManager *networkManager;
@end

@implementation iTunesSearchTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.networkManager = [[ISNetworkManager alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

+ (id)dataFromJSONFileNamed:(NSString *)fileName
{
    //    NSString *resource = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:fileName ofType:@"json"];
    
    if (NSClassFromString(@"NSJSONSerialization")) {
        NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:resource];
        [inputStream open];
        
        return [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:nil];
    }
    else {
        NSData *jsonData = [NSData dataWithContentsOfFile:resource];
        return jsonData;
    }
}


- (void)testParseJSONResponse {
    NSDictionary *jsonArray = [iTunesSearchTests dataFromJSONFileNamed:@"testResponse"];
    [self.networkManager parseJSONResponse:jsonArray];
    XCTAssertTrue(2 == self.networkManager.resultsArray.count, @"2 tracks entered.");
}

- (void)testCreateDateString {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:10];
    [comps setMonth:11];
    [comps setYear:2010];
    NSDate *originalDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    NSString *dateString = [ISNetworkManager createDateString:originalDate];
    NSString *expectedDateString = @"10/11/2010";
    XCTAssertEqualObjects(expectedDateString, dateString, @"The date string did not match the expected date");
}

- (void)testRoundUpPrice {
    NSNumber *aDouble = [NSNumber numberWithDouble:26.32873];
    NSString *roundedUpPrice = [ISNetworkManager roundUpPrice:aDouble];
    NSString *expectedRoundedUpPrice = @"26.33";
    XCTAssertEqualObjects(expectedRoundedUpPrice, roundedUpPrice, @"The price string did not match the expected price");
}

@end
