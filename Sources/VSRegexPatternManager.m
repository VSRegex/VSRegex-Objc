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

@interface VSRegexPatternManager ()

@property (nonatomic, copy) VSRegexDictionary *regexDict;

@end

NSExceptionName const VSRegexPatternManagerBundleNotFoundException = @"com.vincentsit.VSRegex.VSRegexPatternManager.Exception.BundleNotFound";
NSExceptionName const VSRegexPatternManagerJSONFileNotFoundException = @"com.vincentsit.VSRegex.VSRegexPatternManager.Exception.JSONFileNotFound";
NSExceptionName const VSRegexPatternManagerJSONSerializationException = @"com.vincentsit.VSRegex.VSRegexPatternManager.Exception.JSONSerialization";

@implementation VSRegexPatternManager

- (VSRegexDictionary *)regexDict {
  if (!_regexDict) {
#if VSREGEX_TEST
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"VSRegex_ObjcTest")];
#else
    NSURL *bundleURL = [[NSBundle bundleForClass:[self class]].resourceURL URLByAppendingPathComponent:@"VSRegex.bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    if (!bundle) {
      [NSException raise:VSRegexPatternManagerBundleNotFoundException format:@"VSRegex: Failed to load the VSRegex.bundle."];
    }
#endif
    NSURL *fileURL = [bundle URLForResource:@"regex" withExtension:@"json"];
    if (!fileURL) {
      [NSException raise:VSRegexPatternManagerJSONFileNotFoundException format:@"VSRegex: Failed to find the path of regex.json."];
    }
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:fileURL options:kNilOptions error:&error];
    if (!data || error) {
      [NSException raise:error.domain format:@"%@", error.localizedDescription];
    }
    
    _regexDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!_regexDict || 0 == _regexDict.count) {
      [NSException raise:VSRegexPatternManagerJSONSerializationException format:@"VSRegex: Failed to create JSON object."];
    }
  }
  return _regexDict;
}

- (instancetype)initForSingleton {
  self = [super init];
  return self;
}

+ (instancetype)sharedManager {
  static VSRegexPatternManager *manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[VSRegexPatternManager alloc] initForSingleton];
  });
  return manager;
}

- (NSString *)stringForPattern:(VSRegexPattern)pattern {
  NSAssert(pattern >= VSRegexPatternAll && pattern <= VSRegexPatternDataOnlyChinaTelecom,
           ([NSString stringWithFormat:@"Invalid pattern. value: %@", @(pattern)]));
  
  switch (pattern) {
    case VSRegexPatternAll:
      return self.regexDict[@"misc"][@"all"];
    case VSRegexPatternSMS:
      return self.regexDict[@"misc"][@"sms"];
    case VSRegexPatternCarrier:
      return self.regexDict[@"carrier"][@"all"];
    case VSRegexPatternCarrierChinaMobile:
      return self.regexDict[@"carrier"][@"china_mobile"];
    case VSRegexPatternCarrierChinaUnicom:
      return self.regexDict[@"carrier"][@"china_unicom"];
    case VSRegexPatternCarrierChinaTelecom:
      return self.regexDict[@"carrier"][@"china_telecom"];
    case VSRegexPatternCarrierInmarsat:
      return self.regexDict[@"carrier"][@"inmarsat"];
    case VSRegexPatternCarrierMIIT:
      return self.regexDict[@"carrier"][@"miit"];
    case VSRegexPatternMVNO:
      return self.regexDict[@"mvno"][@"all"];
    case VSRegexPatternMVNOChinaMobile:
      return self.regexDict[@"mvno"][@"china_mobile"];
    case VSRegexPatternMVNOChinaUnicom:
      return self.regexDict[@"mvno"][@"china_unicom"];
    case VSRegexPatternMVNOChinaTelecom:
      return self.regexDict[@"mvno"][@"china_telecom"];
    case VSRegexPatternIoT:
      return self.regexDict[@"iot"][@"all"];
    case VSRegexPatternIoTChinaMobile:
      return self.regexDict[@"iot"][@"china_mobile"];
    case VSRegexPatternIoTChinaUnicom:
      return self.regexDict[@"iot"][@"china_unicom"];
    case VSRegexPatternIoTChinaTelecom:
      return self.regexDict[@"iot"][@"china_telecom"];
    case VSRegexPatternDataOnly:
      return self.regexDict[@"data_plan_only"][@"all"];
    case VSRegexPatternDataOnlyChinaMobile:
      return self.regexDict[@"data_plan_only"][@"china_mobile"];
    case VSRegexPatternDataOnlyChinaUnicom:
      return self.regexDict[@"data_plan_only"][@"china_unicom"];
    case VSRegexPatternDataOnlyChinaTelecom:
      return self.regexDict[@"data_plan_only"][@"china_telecom"];
  }
}

- (NSUInteger)minimumLengthForPattern:(VSRegexPattern)pattern {
  switch (pattern) {
    case VSRegexPatternAll:
    case VSRegexPatternSMS:
    case VSRegexPatternCarrier:
    case VSRegexPatternCarrierChinaMobile:
    case VSRegexPatternCarrierChinaUnicom:
    case VSRegexPatternCarrierChinaTelecom:
    case VSRegexPatternCarrierInmarsat:
    case VSRegexPatternCarrierMIIT:
    case VSRegexPatternMVNO:
    case VSRegexPatternMVNOChinaMobile:
    case VSRegexPatternMVNOChinaUnicom:
    case VSRegexPatternMVNOChinaTelecom:
    case VSRegexPatternDataOnly:
    case VSRegexPatternDataOnlyChinaMobile:
    case VSRegexPatternDataOnlyChinaUnicom:
    case VSRegexPatternDataOnlyChinaTelecom:
      return 11;
    case VSRegexPatternIoT:
    case VSRegexPatternIoTChinaMobile:
    case VSRegexPatternIoTChinaUnicom:
    case VSRegexPatternIoTChinaTelecom:
      return 13;
  }
}


#pragma mark - Unavailable

- (instancetype)init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

+ (instancetype)new {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

@end
