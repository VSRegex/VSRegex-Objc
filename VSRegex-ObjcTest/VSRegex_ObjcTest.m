// Copyright (c) 2019 Vincent Sit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <XCTest/XCTest.h>

#import "VSRegex.h"
#import "VSRegexPatternManager.h"
#import "TestDataFetcher.h"

@interface VSRegex_ObjcTest : XCTestCase

@property (nonatomic, copy) NSArray<NSNumber *> *regularExpressionOptions;
@property (nonatomic, copy) NSArray<NSNumber *> *matchingOptions;

@end

@implementation VSRegex_ObjcTest

- (NSArray<NSNumber *> *)regularExpressionOptions {
  if (!_regularExpressionOptions) {
    _regularExpressionOptions = @[@(kNilOptions),
                                  @(NSRegularExpressionCaseInsensitive),
                                  @(NSRegularExpressionAllowCommentsAndWhitespace),
                                  // @(NSRegularExpressionIgnoreMetacharacters),
                                  @(NSRegularExpressionDotMatchesLineSeparators),
                                  @(NSRegularExpressionAnchorsMatchLines),
                                  @(NSRegularExpressionUseUnixLineSeparators),
                                  @(NSRegularExpressionUseUnicodeWordBoundaries)];
  }
  return _regularExpressionOptions;
}

- (NSArray<NSNumber *> *)matchingOptions {
  if (!_matchingOptions) {
    _matchingOptions = @[@(kNilOptions),
                         @(NSMatchingReportProgress),
                         @(NSMatchingReportCompletion),
                         @(NSRegularExpressionIgnoreMetacharacters),
                         @(NSMatchingAnchored),
                         @(NSMatchingWithTransparentBounds),
                         @(NSMatchingWithoutAnchoringBounds)];
  }
  return _matchingOptions;
}

- (NSUInteger)optionWithOptions:(NSArray<NSNumber *> *)options atIndex:(NSUInteger)index {
  NSAssert(index < options.count, nil);
  
  NSNumber *option = [[options subarrayWithRange:NSMakeRange(0, index)] vs_reduce:@0 block:^id _Nonnull(id  _Nonnull obj1, id  _Nonnull obj2) {
    return @([obj1 unsignedIntegerValue] | [obj2 unsignedIntegerValue]);
  }];
  return [option unsignedIntegerValue];
}

- (void)testCreate {
  for (NSUInteger pattern = VSRegexPatternAll; pattern <= VSRegexPatternDataOnlyChinaTelecom; pattern++) {
    XCTAssertNotNil([[VSRegex alloc] initWithPattern:pattern]);
    
    [self.regularExpressionOptions enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSRegularExpressionOptions option = [self optionWithOptions:self.regularExpressionOptions atIndex:idx];
      XCTAssertNotNil([[VSRegex alloc] initWithPattern:pattern options:option error:nil]);
    }];
  }
}

- (void)testFirstMatch {
  for (NSUInteger pattern = VSRegexPatternAll; pattern <= VSRegexPatternDataOnlyChinaTelecom; pattern++) {
    NSArray *testNumbers = [[TestDataFetcher sharedFetcher] testNumbersForPattern:pattern];
    XCTAssertTrue(testNumbers.count > 0);
    
    for (NSInteger reOptionIndex = 0; reOptionIndex < self.regularExpressionOptions.count; reOptionIndex++) {
      NSRegularExpressionOptions regularExpressionOptions = [self optionWithOptions:self.regularExpressionOptions atIndex:reOptionIndex];
      
      VSRegex *regex = [[VSRegex alloc] initWithPattern:pattern options:regularExpressionOptions error:nil];
      XCTAssertNotNil(regex);
      
      for (NSInteger matchingOptionIndex = 0; matchingOptionIndex < self.matchingOptions.count; matchingOptionIndex++) {
        NSMatchingOptions matchingOptions = [self optionWithOptions:self.matchingOptions atIndex:matchingOptionIndex];
        
        for (NSString *number in testNumbers) {
          XCTAssertNotNil([regex firstMatchWithString:number options:matchingOptions]);
          XCTAssertNotNil([regex firstMatchWithString:number options:matchingOptions range:NSMakeRange(0, number.length)]);
          XCTAssertNil([regex firstMatchWithString:number options:matchingOptions range:NSMakeRange(0, 1)]);
        }
      }
    }
  }
}

- (void)testFirstMatchWithReservedNumbers {
  NSArray *testNumbers = [TestDataFetcher sharedFetcher].reservedNumbers;
  XCTAssertTrue(testNumbers.count > 0);
  
  for (NSUInteger pattern = VSRegexPatternAll; pattern <= VSRegexPatternDataOnlyChinaTelecom; pattern++) {
    for (NSInteger reOptionIndex = 0; reOptionIndex < self.regularExpressionOptions.count; reOptionIndex++) {
      NSRegularExpressionOptions regularExpressionOptions = [self optionWithOptions:self.regularExpressionOptions atIndex:reOptionIndex];
      
      VSRegex *regex = [[VSRegex alloc] initWithPattern:pattern options:regularExpressionOptions error:nil];
      XCTAssertNotNil(regex);
      
      for (NSInteger matchingOptionIndex = 0; matchingOptionIndex < self.matchingOptions.count; matchingOptionIndex++) {
        NSMatchingOptions matchingOptions = [self optionWithOptions:self.matchingOptions atIndex:matchingOptionIndex];
        
        for (NSString *number in testNumbers) {
          XCTAssertNil([regex firstMatchWithString:number options:matchingOptions]);
          XCTAssertNil([regex firstMatchWithString:number options:matchingOptions range:NSMakeRange(0, number.length)]);
          XCTAssertNil([regex firstMatchWithString:number options:matchingOptions range:NSMakeRange(0, 1)]);
        }
      }
    }
  }
}

- (void)testAllMatches {
  for (NSUInteger pattern = VSRegexPatternAll; pattern <= VSRegexPatternDataOnlyChinaTelecom; pattern++) {
    NSArray *testNumbers = [[TestDataFetcher sharedFetcher] testNumbersForPattern:pattern];
    NSUInteger minimumLength = [[VSRegexPatternManager sharedManager] minimumLengthForPattern:pattern];
    XCTAssertTrue(testNumbers.count > 0);
    
    for (NSInteger reOptionIndex = 0; reOptionIndex < self.regularExpressionOptions.count; reOptionIndex++) {
      NSRegularExpressionOptions regularExpressionOptions = [self optionWithOptions:self.regularExpressionOptions atIndex:reOptionIndex];
      
      VSRegex *regex = [[VSRegex alloc] initWithPattern:pattern options:regularExpressionOptions error:nil];
      XCTAssertNotNil(regex);
      
      for (NSInteger matchingOptionIndex = 0; matchingOptionIndex < self.matchingOptions.count; matchingOptionIndex++) {
        NSMatchingOptions matchingOptions = [self optionWithOptions:self.matchingOptions atIndex:matchingOptionIndex];
        NSArray *matches = [regex allMatchesWithStrings:testNumbers options:matchingOptions];
        XCTAssertNotNil(matches);
        XCTAssertTrue(matches.count > 0);
        
        matches = [regex allMatchesWithStrings:testNumbers options:matchingOptions range:NSMakeRange(0, minimumLength)];
        XCTAssertNotNil(matches);
        XCTAssertTrue(matches.count > 0);
        
        /// The reason is that when the range parameter is specified,
        /// the minimum required length for matching all numbers case is 11,
        /// while the IoT number length is 13,
        /// so the matching result does not include the IoT number.
        if (VSRegexPatternAll == pattern) {
          XCTAssertTrue(matches.count != testNumbers.count);
        } else {
          XCTAssertTrue(matches.count == testNumbers.count);
        }
        
        matches = [regex allMatchesWithStrings:testNumbers options:matchingOptions range:NSMakeRange(0, 1)];
        XCTAssertNotNil(matches);
        XCTAssertTrue(0 == matches.count);
      }
    }
  }
}

- (void)testAllMatchesWithReservedNumbers {
  NSArray *testNumbers = [TestDataFetcher sharedFetcher].reservedNumbers;
  XCTAssertTrue(testNumbers.count > 0);
  
  for (NSUInteger pattern = VSRegexPatternAll; pattern <= VSRegexPatternDataOnlyChinaTelecom; pattern++) {
    NSUInteger minimumLength = [[VSRegexPatternManager sharedManager] minimumLengthForPattern:pattern];
    
    for (NSInteger reOptionIndex = 0; reOptionIndex < self.regularExpressionOptions.count; reOptionIndex++) {
      NSRegularExpressionOptions regularExpressionOptions = [self optionWithOptions:self.regularExpressionOptions atIndex:reOptionIndex];
      
      VSRegex *regex = [[VSRegex alloc] initWithPattern:pattern options:regularExpressionOptions error:nil];
      XCTAssertNotNil(regex);
      
      for (NSInteger matchingOptionIndex = 0; matchingOptionIndex < self.matchingOptions.count; matchingOptionIndex++) {
        NSMatchingOptions matchingOptions = [self optionWithOptions:self.matchingOptions atIndex:matchingOptionIndex];
        NSArray *matches = [regex allMatchesWithStrings:testNumbers options:matchingOptions];
        XCTAssertNotNil(matches);
        XCTAssertTrue(0 == matches.count);
        
        matches = [regex allMatchesWithStrings:testNumbers options:matchingOptions range:NSMakeRange(0, minimumLength)];
        XCTAssertNotNil(matches);
        XCTAssertTrue(0 == matches.count);
        
        matches = [regex allMatchesWithStrings:testNumbers options:matchingOptions range:NSMakeRange(0, 1)];
        XCTAssertNotNil(matches);
        XCTAssertTrue(0 == matches.count);
      }
    }
  }
}

- (void)testMatches {
  for (NSUInteger pattern = VSRegexPatternAll; pattern <= VSRegexPatternDataOnlyChinaTelecom; pattern++) {
    NSArray *testNumbers = [[TestDataFetcher sharedFetcher] testNumbersForPattern:pattern];
    XCTAssertTrue(testNumbers.count > 0);
    
    for (NSInteger reOptionIndex = 0; reOptionIndex < self.regularExpressionOptions.count; reOptionIndex++) {
      NSRegularExpressionOptions regularExpressionOptions = [self optionWithOptions:self.regularExpressionOptions atIndex:reOptionIndex];
      
      VSRegex *regex = [[VSRegex alloc] initWithPattern:pattern options:regularExpressionOptions error:nil];
      XCTAssertNotNil(regex);
      
      for (NSInteger matchingOptionIndex = 0; matchingOptionIndex < self.matchingOptions.count; matchingOptionIndex++) {
        NSMatchingOptions matchingOptions = [self optionWithOptions:self.matchingOptions atIndex:matchingOptionIndex];
        
        for (NSString *number in testNumbers) {
          XCTAssertTrue([regex matchesWithString:number options:matchingOptions]);
          XCTAssertTrue([regex matchesWithString:number options:matchingOptions range:NSMakeRange(0, number.length)]);
          XCTAssertFalse([regex matchesWithString:number options:matchingOptions range:NSMakeRange(0, 1)]);
        }
      }
    }
  }
}

- (void)testMatchesWithReservedNumbers {
  NSArray *testNumbers = [TestDataFetcher sharedFetcher].reservedNumbers;
  XCTAssertTrue(testNumbers.count > 0);
  
  for (NSUInteger pattern = VSRegexPatternAll; pattern <= VSRegexPatternDataOnlyChinaTelecom; pattern++) {
    for (NSInteger reOptionIndex = 0; reOptionIndex < self.regularExpressionOptions.count; reOptionIndex++) {
      NSRegularExpressionOptions regularExpressionOptions = [self optionWithOptions:self.regularExpressionOptions atIndex:reOptionIndex];
      
      VSRegex *regex = [[VSRegex alloc] initWithPattern:pattern options:regularExpressionOptions error:nil];
      XCTAssertNotNil(regex);
      
      for (NSInteger matchingOptionIndex = 0; matchingOptionIndex < self.matchingOptions.count; matchingOptionIndex++) {
        NSMatchingOptions matchingOptions = [self optionWithOptions:self.matchingOptions atIndex:matchingOptionIndex];
        
        for (NSString *number in testNumbers) {
          XCTAssertFalse([regex matchesWithString:number options:matchingOptions]);
          XCTAssertFalse([regex matchesWithString:number options:matchingOptions range:NSMakeRange(0, number.length)]);
          XCTAssertFalse([regex matchesWithString:number options:matchingOptions range:NSMakeRange(0, 1)]);
        }
      }
    }
  }
}

- (void)testClassMethod {
  for (NSUInteger pattern = VSRegexPatternAll; pattern <= VSRegexPatternDataOnlyChinaTelecom; pattern++) {
    NSArray *testNumbers = [[TestDataFetcher sharedFetcher] testNumbersForPattern:pattern];
    XCTAssertTrue(testNumbers.count > 0);
    
    for (NSInteger reOptionIndex = 0; reOptionIndex < self.regularExpressionOptions.count; reOptionIndex++) {
      NSRegularExpressionOptions regularExpressionOptions = [self optionWithOptions:self.regularExpressionOptions atIndex:reOptionIndex];
      
      for (NSInteger matchingOptionIndex = 0; matchingOptionIndex < self.matchingOptions.count; matchingOptionIndex++) {
        NSMatchingOptions matchingOptions = [self optionWithOptions:self.matchingOptions atIndex:matchingOptionIndex];
        
        for (NSString *number in testNumbers) {
          XCTAssertTrue(
          [VSRegex matchesWithString:number
                             pattern:pattern
            regularExpressionOptions:regularExpressionOptions
                     matchingOptions:matchingOptions]
                        );
        }
      }
    }
  }
}

@end
