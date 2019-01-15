//
//  TestDataFetcher.m
//  VSRegex-ObjcTest
//
//  Created by VincentXue on 1/15/19.
//

#import "TestDataFetcher.h"

@interface TestDataFetcher ()

@property (nonatomic, strong) TestDataFetcherJSON *jsonData;

@end

@implementation TestDataFetcher
@synthesize reservedNumbers = _reservedNumbers;

- (TestDataFetcherJSON *)jsonData {
  if (!_jsonData) {
    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/VincentSit/ChinaMobilePhoneNumberRegex/test/test_data.json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    _jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSAssert(_jsonData, @"Failed to load test data.");
  }
  return _jsonData;
}

- (NSArray<NSString *> *)reservedNumbers {
  if (!_reservedNumbers) {
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:self.jsonData[@"reserved"][@"iot"]];
    [array addObjectsFromArray:self.jsonData[@"reserved"][@"carrier"]];
    _reservedNumbers = [array vs_map:^id _Nonnull(id  _Nonnull obj) {
      return [obj stringValue];
    }];
  }
  return _reservedNumbers;
}

+ (instancetype)sharedFetcher {
  static TestDataFetcher *fetcher = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    fetcher = [[TestDataFetcher alloc] init];
  });
  return fetcher;
}

- (NSArray<NSString *> *)testNumbersForPattern:(VSRegexPattern)pattern {
  return [[self _testNumbersForPattern:pattern] vs_map:^id _Nonnull(id  _Nonnull obj) {
    return [obj stringValue];
  }];
}

#pragma mark - Private

- (NSArray<NSNumber *> *)_testNumbersForPattern:(VSRegexPattern)pattern {
  NSAssert(pattern >= VSRegexPatternAll && pattern <= VSRegexPatternDataOnlyChinaTelecom,
           ([NSString stringWithFormat:@"Invalid pattern. value: %@", @(pattern)]));
  
  switch (pattern) {
    case VSRegexPatternAll: {
      NSMutableArray *array = [NSMutableArray array];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternSMS]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternIoT]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternIoTChinaMobile]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternIoTChinaUnicom]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternIoTChinaTelecom]];
      return [array copy];
    }
    case VSRegexPatternSMS: {
      NSMutableArray *array = [NSMutableArray array];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternCarrier]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternCarrierChinaMobile]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternCarrierChinaUnicom]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternCarrierChinaTelecom]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternCarrierInmarsat]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternCarrierMIIT]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternMVNO]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternMVNOChinaMobile]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternMVNOChinaUnicom]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternMVNOChinaTelecom]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternDataOnly]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternDataOnlyChinaMobile]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternDataOnlyChinaUnicom]];
      [array addObjectsFromArray:[self _testNumbersForPattern:VSRegexPatternDataOnlyChinaTelecom]];
      return [array copy];
    }
    case VSRegexPatternCarrier:
      return [self.jsonData[@"carrier"].allValues vs_reduce:@[] block:^id _Nonnull(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 arrayByAddingObjectsFromArray:obj2];
      }];
    case VSRegexPatternCarrierChinaMobile:
      return self.jsonData[@"carrier"][@"china_mobile"];
    case VSRegexPatternCarrierChinaUnicom:
      return self.jsonData[@"carrier"][@"china_unicom"];
    case VSRegexPatternCarrierChinaTelecom:
      return self.jsonData[@"carrier"][@"china_telecom"];
    case VSRegexPatternCarrierInmarsat:
      return self.jsonData[@"carrier"][@"inmarsat"];
    case VSRegexPatternCarrierMIIT:
      return self.jsonData[@"carrier"][@"miit"];
    case VSRegexPatternMVNO:
      return [self.jsonData[@"mvno"].allValues vs_reduce:@[] block:^id _Nonnull(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 arrayByAddingObjectsFromArray:obj2];
      }];
    case VSRegexPatternMVNOChinaMobile:
      return self.jsonData[@"mvno"][@"china_mobile"];
    case VSRegexPatternMVNOChinaUnicom:
      return self.jsonData[@"mvno"][@"china_unicom"];
    case VSRegexPatternMVNOChinaTelecom:
      return self.jsonData[@"mvno"][@"china_telecom"];
    case VSRegexPatternIoT:
      return [self.jsonData[@"iot"].allValues vs_reduce:@[] block:^id _Nonnull(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 arrayByAddingObjectsFromArray:obj2];
      }];
    case VSRegexPatternIoTChinaMobile:
      return self.jsonData[@"iot"][@"china_mobile"];
    case VSRegexPatternIoTChinaUnicom:
      return self.jsonData[@"iot"][@"china_unicom"];
    case VSRegexPatternIoTChinaTelecom:
      return self.jsonData[@"iot"][@"china_telecom"];
    case VSRegexPatternDataOnly:
      return [self.jsonData[@"data_plan_only"].allValues vs_reduce:@[] block:^id _Nonnull(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 arrayByAddingObjectsFromArray:obj2];
      }];
    case VSRegexPatternDataOnlyChinaMobile:
      return self.jsonData[@"data_plan_only"][@"china_mobile"];
    case VSRegexPatternDataOnlyChinaUnicom:
      return self.jsonData[@"data_plan_only"][@"china_unicom"];
    case VSRegexPatternDataOnlyChinaTelecom:
      return self.jsonData[@"data_plan_only"][@"china_telecom"];
  }
}

@end

#pragma mark -

@implementation NSArray (HOF)

- (NSArray *)vs_map:(id (^)(id obj))block {
  NSMutableArray *mutableArray = [NSMutableArray new];
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [mutableArray addObject:block(obj)];
  }];
  return [mutableArray copy];
}

- (id)vs_reduce:(id)initial block:(id (^)(id obj1, id obj2))block {
  __block id obj = initial;
  [self enumerateObjectsUsingBlock:^(id _obj, NSUInteger idx, BOOL *stop) {
    obj = block(obj, _obj);
  }];
  return obj;
}

@end
