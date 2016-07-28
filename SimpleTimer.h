//
//  Created by Alexander Stepanov on 28/07/16.
//  Copyright © 2016 Alexander Stepanov. All rights reserved.
//

#import <Foundation/Foundation.h>

// timer_once(2.0) { };
// timer_repeat(3.0) { };

// timer_stop_all();

// timer_once(5.0, @"timer1") { };
// timer_stop(@"timer1")


#define timer_once(seconds, ...)    _timer_start(seconds, NO, ##__VA_ARGS__)
#define timer_repeat(seconds, ...)  _timer_start(seconds, YES, ##__VA_ARGS__)
#define timer_stop(key)             [self _simpleTimer_stop:key]
#define timer_stop_all()            [self _simpleTimer_stopAll];

#define _timer_macro(_0, X, ...) X
#define _timer_start(seconds, rp, ...) \
[self _simpleTimer_startWithTimeInterval:seconds repeats:rp key: _timer_macro(seconds, ##__VA_ARGS__, nil)]; \
self._simpleTimer_block = ^(__typeof(self) self)


@interface NSObject (SimpleTimer)

-(void)_simpleTimer_startWithTimeInterval:(NSTimeInterval)tm repeats:(BOOL)repeats key:(NSString*)key;
-(void)set_simpleTimer_block:(id)block;

-(void)_simpleTimer_stop:(NSString*)key;
-(void)_simpleTimer_stopAll;

@end
