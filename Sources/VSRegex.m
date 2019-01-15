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

#import "VSRegex.h"
#import "VSRegexPatternManager.h"

@interface VSRegex ()

@property (nonatomic, assign) VSRegexPattern matchingPattern;
@property (nonatomic, strong) NSRegularExpression *regularExpression;

@end

static NSRange const kNilRange = {0, 0};

@implementation VSRegex

- (nullable instancetype)init {
  return [self initWithPattern:VSRegexPatternAll];
}

- (nullable instancetype)initWithPattern:(VSRegexPattern)pattern {
  return [self initWithPattern:pattern options:kNilOptions error:nil];
}

- (nullable instancetype)initWithPattern:(VSRegexPattern)pattern
                                 options:(NSRegularExpressionOptions)options
                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error {
  self = [super init];
  if (self) {
    _matchingPattern = pattern;
    NSString *patternString = [[VSRegexPatternManager sharedManager] stringForPattern:pattern];
    _regularExpression = [NSRegularExpression regularExpressionWithPattern:patternString options:options error:error];
    
    if (!_regularExpression) {
      return nil;
    }
  }
  return self;
}

- (nullable NSString *)firstMatchWithString:(NSString *)string {
  return [self firstMatchWithString:string options:kNilOptions range:kNilRange];
}

- (nullable NSString *)firstMatchWithString:(NSString *)string options:(NSMatchingOptions)options {
  return [self firstMatchWithString:string options:options range:kNilRange];
}

- (nullable NSString *)firstMatchWithString:(NSString *)string range:(NSRange)range {
  return [self firstMatchWithString:string options:kNilOptions range:range];
}

- (nullable NSString *)firstMatchWithString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range {
  NSUInteger minimumLength = [[VSRegexPatternManager sharedManager] minimumLengthForPattern:self.matchingPattern];
  if (string.length < minimumLength) {
    return nil;
  }
  
  NSRange newRange = NSEqualRanges(kNilRange, range) ? NSMakeRange(0, string.length) : range;
  if (newRange.length - newRange.location < minimumLength) {
    return nil;
  }
  
  NSTextCheckingResult *result = [self.regularExpression firstMatchInString:string options:options range:newRange];
  if (!result) {
    return nil;
  }
  
  return [string substringWithRange:result.range];
}

- (NSArray *)allMatchesWithStrings:(NSArray<NSString *> *)strings {
  return [self allMatchesWithStrings:strings options:kNilOptions range:kNilRange];
}

- (NSArray *)allMatchesWithStrings:(NSArray<NSString *> *)strings options:(NSMatchingOptions)options {
  return [self allMatchesWithStrings:strings options:options range:kNilRange];
}

- (NSArray *)allMatchesWithStrings:(NSArray<NSString *> *)strings range:(NSRange)range {
  return [self allMatchesWithStrings:strings options:kNilOptions range:range];
}

- (NSArray<NSString *> *)allMatchesWithStrings:(NSArray<NSString *> *)strings options:(NSMatchingOptions)options range:(NSRange)range {
  if (strings.count <= 0) {
    return @[];
  }
  
  NSUInteger minimumLength = [[VSRegexPatternManager sharedManager] minimumLengthForPattern:self.matchingPattern];
  NSMutableArray *matches = [NSMutableArray array];
  
  for (NSString *string in strings) {
    if (string.length < minimumLength) {
      continue;
    }
    
    NSRange newRange = NSEqualRanges(kNilRange, range) ? NSMakeRange(0, string.length) : range;
    if (newRange.length - newRange.location < minimumLength) {
      continue;
    }
    
    NSArray *results = [self.regularExpression matchesInString:string options:options range:newRange];
    for (NSTextCheckingResult *match in results) {
      [matches addObject:[string substringWithRange:match.range]];
    }
  }
  
  return matches;
}

- (BOOL)matchesWithString:(NSString *)string {
  return [self matchesWithString:string options:kNilOptions range:kNilRange];
}

- (BOOL)matchesWithString:(NSString *)string options:(NSMatchingOptions)options {
  return [self matchesWithString:string options:options range:kNilRange];
}

- (BOOL)matchesWithString:(NSString *)string range:(NSRange)range {
  return [self matchesWithString:string options:kNilOptions range:range];
}

- (BOOL)matchesWithString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range {
  return [self firstMatchWithString:string options:options range:range] != nil;
}

+ (BOOL)matchesWithString:(NSString *)string {
  return [self matchesWithString:string
                         pattern:VSRegexPatternAll
        regularExpressionOptions:kNilOptions
                 matchingOptions:kNilOptions
                           range:kNilRange];
}

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern {
  return [self matchesWithString:string
                         pattern:pattern
        regularExpressionOptions:kNilOptions
                 matchingOptions:kNilOptions
                           range:kNilRange];
}

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
 regularExpressionOptions:(NSRegularExpressionOptions)regularExpressionOptions {
  return [self matchesWithString:string
                         pattern:pattern
        regularExpressionOptions:regularExpressionOptions
                 matchingOptions:kNilOptions
                           range:kNilRange];
}

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
          matchingOptions:(NSMatchingOptions)matchingOptions {
  return [self matchesWithString:string
                         pattern:pattern
        regularExpressionOptions:kNilOptions
                 matchingOptions:matchingOptions
                           range:kNilRange];
}

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
                    range:(NSRange)range {
  return [self matchesWithString:string
                         pattern:pattern
        regularExpressionOptions:kNilOptions
                 matchingOptions:kNilOptions
                           range:range];
}

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
 regularExpressionOptions:(NSRegularExpressionOptions)regularExpressionOptions
          matchingOptions:(NSMatchingOptions)matchingOptions {
  return [self matchesWithString:string
                         pattern:pattern
        regularExpressionOptions:regularExpressionOptions
                 matchingOptions:matchingOptions
                           range:kNilRange];
}

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
 regularExpressionOptions:(NSRegularExpressionOptions)regularExpressionOptions
                    range:(NSRange)range {
  return [self matchesWithString:string
                         pattern:pattern
        regularExpressionOptions:regularExpressionOptions
                 matchingOptions:kNilOptions
                           range:range];
}

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
          matchingOptions:(NSMatchingOptions)matchingOptions
                    range:(NSRange)range {
  return [self matchesWithString:string
                         pattern:pattern
        regularExpressionOptions:kNilOptions
                 matchingOptions:matchingOptions
                           range:range];
}

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
 regularExpressionOptions:(NSRegularExpressionOptions)regularExpressionOptions
          matchingOptions:(NSMatchingOptions)matchingOptions
                    range:(NSRange)range {
  VSRegex *regex = [[VSRegex alloc] initWithPattern:pattern options:regularExpressionOptions error:nil];
  return [regex matchesWithString:string options:matchingOptions range:range];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }
  
  if (![object isKindOfClass:[self class]]) {
    return NO;
  }
  
  VSRegex *regex = object;
  
  return self.matchingPattern == regex.matchingPattern
  && [self.regularExpression isEqual:regex.regularExpression];
}

- (NSUInteger)hash {
  return self.matchingPattern ^ [self.regularExpression hash];
}

#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  VSRegex *regex = [[[self class] allocWithZone:zone] init];
  regex.matchingPattern = self.matchingPattern;
  regex.regularExpression = self.regularExpression;
  return regex;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding{
  return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
  [aCoder encodeObject:@(self.matchingPattern) forKey:NSStringFromSelector(@selector(matchingPattern))];
  [aCoder encodeObject:self.regularExpression forKey:NSStringFromSelector(@selector(regularExpression))];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    self.matchingPattern = [[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(matchingPattern))] unsignedIntegerValue];
    self.regularExpression = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(regularExpression))];
  }
  return self;
}

@end
