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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSExceptionName const VSRegexPatternManagerBundleNotFoundException;
FOUNDATION_EXPORT NSExceptionName const VSRegexPatternManagerJSONFileNotFoundException;
FOUNDATION_EXPORT NSExceptionName const VSRegexPatternManagerJSONSerializationException;

typedef NSDictionary<NSString *, NSDictionary<NSString *, NSString *> *> VSRegexDictionary;

/**
 Regular expression patterns for used to match mobile numbers in mainland China.
 
 - VSRegexPatternAll: Match all numbers. (Phone number + IoT number + Data only number)
 - VSRegexPatternSMS: Match all numbers with SMS. (Phone number + Data only number)
 - VSRegexPatternCarrier: Match all the carrier mobile numbers.
 - VSRegexPatternCarrierChinaMobile: Match the China Mobile mobile numbers.
 - VSRegexPatternCarrierChinaUnicom: Match the China Unicom mobile numbers.
 - VSRegexPatternCarrierChinaTelecom: Match the China Telecom mobile numbers.
 - VSRegexPatternCarrierInmarsat: Match the inmarsat mobile numbers.
 - VSRegexPatternCarrierMIIT: Match the miit mobile numbers.
 - VSRegexPatternMVNO: Match all the MVNO mobile numbers.
 - VSRegexPatternMVNOChinaMobile: Match the mobile number of China Mobile operated by the MVNO.
 - VSRegexPatternMVNOChinaUnicom: Match the mobile number of China Unicom operated by the MVNO.
 - VSRegexPatternMVNOChinaTelecom: Match the mobile number of China Telecom operated by the MVNO.
 - VSRegexPatternIoT: Match all the IoT numbers.
 - VSRegexPatternIoTChinaMobile: Match the IoT numbers belonging to China Mobile.
 - VSRegexPatternIoTChinaUnicom: Match the IoT numbers belonging to China Unicom.
 - VSRegexPatternIoTChinaTelecom: Match the IoT numbers belonging to China Telecom.
 - VSRegexPatternDataOnly: Match all the data-plans only numbers.
 - VSRegexPatternDataOnlyChinaMobile: Match the data-plans only numbers belonging to China Mobile.
 - VSRegexPatternDataOnlyChinaUnicom: Match the data-plans only numbers belonging to China Unicom.
 - VSRegexPatternDataOnlyChinaTelecom: Match the data-plans only numbers belonging to China Telecom.
 */
typedef NS_ENUM(NSUInteger, VSRegexPattern) {
  VSRegexPatternAll,
  VSRegexPatternSMS,
  VSRegexPatternCarrier,
  VSRegexPatternCarrierChinaMobile,
  VSRegexPatternCarrierChinaUnicom,
  VSRegexPatternCarrierChinaTelecom,
  VSRegexPatternCarrierInmarsat,
  VSRegexPatternCarrierMIIT,
  VSRegexPatternMVNO,
  VSRegexPatternMVNOChinaMobile,
  VSRegexPatternMVNOChinaUnicom,
  VSRegexPatternMVNOChinaTelecom,
  VSRegexPatternIoT,
  VSRegexPatternIoTChinaMobile,
  VSRegexPatternIoTChinaUnicom,
  VSRegexPatternIoTChinaTelecom,
  VSRegexPatternDataOnly,
  VSRegexPatternDataOnlyChinaMobile,
  VSRegexPatternDataOnlyChinaUnicom,
  VSRegexPatternDataOnlyChinaTelecom
};

/**
 A helper class that handles regular expression patterns.
 */
@interface VSRegexPatternManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// Singleton object. This class does not allow you to create other objects.
+ (instancetype)sharedManager;

/**
 Get the regular expression pattern string.

 @param pattern The pattern that needs to get the string.
 @return A string for the specified pattern.
 */
- (NSString *)stringForPattern:(VSRegexPattern)pattern;

/**
 Get the minimum length of the matching string required by the regular expression pattern.

 @param pattern The pattern that needs to get the length.
 @return An integer representing the minimum length of the string being matched.
 */
- (NSUInteger)minimumLengthForPattern:(VSRegexPattern)pattern;

@end

NS_ASSUME_NONNULL_END
