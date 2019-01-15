//
//  TestDataFetcher.h
//  VSRegex-ObjcTest
//
//  Created by VincentXue on 1/15/19.
//

#import <Foundation/Foundation.h>
#import "VSRegex.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSDictionary<NSString *, NSDictionary<NSString *, NSArray<NSNumber *> *> *> TestDataFetcherJSON;

@interface TestDataFetcher : NSObject

@property (nonatomic, copy, readonly) NSArray<NSString *> *reservedNumbers;

+ (instancetype)sharedFetcher;
- (NSArray<NSString *> *)testNumbersForPattern:(VSRegexPattern)pattern;

@end

@interface NSArray (HOF)

- (NSArray *)vs_map:(id (^)(id obj))block;
- (id)vs_reduce:(id)initial block:(id (^)(id obj1, id obj2))block;

@end

NS_ASSUME_NONNULL_END
