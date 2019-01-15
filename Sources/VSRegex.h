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

#import "VSRegexPatternManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 An object that used to match mobile numbers in mainland China.
 */
@interface VSRegex : NSObject <NSCopying, NSSecureCoding>

/// The regular expression matching pattern for this object.
@property (nonatomic, assign, readonly) VSRegexPattern matchingPattern;

/// The NSRegularExpression object that really does the matching work.
@property (nonatomic, strong, readonly) NSRegularExpression *regularExpression;

/**
 Create a `VSRegex` object based on pattern and regular expression options.
 
 @param pattern The regular expression pattern to compile.
 @param options The regular expression options that are applied to the expression during matching.
 @param error The error that occurred while attempting to create the NSRegularExpression object.
 @return A VSRegex object for matching mobile phone numbers in mainland China.
 */
- (nullable instancetype)initWithPattern:(VSRegexPattern)pattern
                                 options:(NSRegularExpressionOptions)options
                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error;
- (nullable instancetype)initWithPattern:(VSRegexPattern)pattern;
- (nullable instancetype)init;

/**
 Search for the first string that matches the `matchingPattern`.
 
 @param string The string to match against.
 @param options The regular expression matching options that are applied to the expression during matching.
 @param range The range of the string to search.
 @return An `NSString` object describing the first match, or `nil`.
 */
- (nullable NSString *)firstMatchWithString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range;
- (nullable NSString *)firstMatchWithString:(NSString *)string;
- (nullable NSString *)firstMatchWithString:(NSString *)string options:(NSMatchingOptions)options;
- (nullable NSString *)firstMatchWithString:(NSString *)string range:(NSRange)range;

/**
 Search for all strings that match the `matchingPattern`.
 
 @param strings The string array to match against.
 @param options The regular expression matching options that are applied to the expression during matching.
 @param range he range of each string to search.
 @return An array of `NSString` describing every match, or an empty array.
 */
- (NSArray<NSString *> *)allMatchesWithStrings:(NSArray<NSString *> *)strings options:(NSMatchingOptions)options range:(NSRange)range;
- (NSArray *)allMatchesWithStrings:(NSArray<NSString *> *)strings;
- (NSArray *)allMatchesWithStrings:(NSArray<NSString *> *)strings options:(NSMatchingOptions)options;
- (NSArray *)allMatchesWithStrings:(NSArray<NSString *> *)strings range:(NSRange)range;

/**
 Tests if the string matches the `matchingPattern` with the specified parameters.
 
 @param string The string to match against.
 @param options The regular expression matching options that are applied to the expression during matching.
 @param range The range of the string to search.
 @return `YES` if the regular expression matches, otherwise `NO`.
 */
- (BOOL)matchesWithString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range;
- (BOOL)matchesWithString:(NSString *)string;
- (BOOL)matchesWithString:(NSString *)string options:(NSMatchingOptions)options;
- (BOOL)matchesWithString:(NSString *)string range:(NSRange)range;

/**
 Tests if the string matches the `matchingPattern` with the specified parameters.
 
 @param string The string to match against.
 @param pattern The regular expression pattern to compile.
 @param regularExpressionOptions The regular expression options that are applied to the expression during matching.
 @param matchingOptions The regular expression matching options that are applied to the expression during matching.
 @param range The range of the string to search.
 @return `YES` if the regular expression matches, otherwise `NO`.
 */
+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
 regularExpressionOptions:(NSRegularExpressionOptions)regularExpressionOptions
          matchingOptions:(NSMatchingOptions)matchingOptions
                    range:(NSRange)range;

+ (BOOL)matchesWithString:(NSString *)string;

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern;

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
 regularExpressionOptions:(NSRegularExpressionOptions)regularExpressionOptions;

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
          matchingOptions:(NSMatchingOptions)matchingOptions;

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
                    range:(NSRange)range;

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
 regularExpressionOptions:(NSRegularExpressionOptions)regularExpressionOptions
          matchingOptions:(NSMatchingOptions)matchingOptions;

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
 regularExpressionOptions:(NSRegularExpressionOptions)regularExpressionOptions
                    range:(NSRange)range;

+ (BOOL)matchesWithString:(NSString *)string
                  pattern:(VSRegexPattern)pattern
          matchingOptions:(NSMatchingOptions)matchingOptions
                    range:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
