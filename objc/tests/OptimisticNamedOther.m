/**
 *    Copyright (c) 2019 Uber Technologies, Inc.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@protocol UBAdvancedExperimenting

- (BOOL)optimisticFeatureFlagEnabledForExperiment:(NSString *)experimentKey;

@end

@interface UBDependencyGraph : NSObject

+ (UBDependencyGraph *)currentGraph;

- (nullable id)implementationForProtocol:(Protocol *)protocol;

@end

/**
 See UBOptimisticNamedFeatureFlag. This is a helper macro.
 */
#define UBOptimisticNamedFeatureFlagIsEnabled(flagName)                  \
  ([[[UBDependencyGraph currentGraph]                                    \
      implementationForProtocol:@protocol(UBAdvancedExperimenting)]      \
      optimisticFeatureFlagEnabledForExperiment:                         \
          [NSString stringWithFormat:@"ios_%@_wide_optimistic_rollback", \
                                     [@ #flagName lowercaseString]]])

#define UBOptimisticNamedFeatureFlag(flagName) \
  if (UBOptimisticNamedFeatureFlagIsEnabled(flagName))


@implementation OptimisticTest

- (void)optimisticFeatureFlag_macro {
  UBOptimisticNamedFeatureFlag(optimistic_stale_flag) {
    NSLog(@"1");
  }
  else {
    NSLog(@"2");
  }
}

@end
