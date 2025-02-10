#import "RTNCalculator.h"

#import <Security/Security.h>
#import <React/RCTConvert.h>
#import <React/RCTUtils.h>

@implementation RTNCalculator

RCT_EXPORT_MODULE(RTNCalculator)

- (void)add:(double)a b:(double)b resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    NSNumber *result = [[NSNumber alloc] initWithInteger:a+b+a];
    resolve(result);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRTNCalculatorSpecJSI>(params);
}

- (void)setItem:(NSString*)key value:(NSString*)value resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {

    NSData* valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary* search = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      (__bridge id)(kSecClassGenericPassword), kSecClass,
                                      @"app", kSecAttrService,
                                      kSecAttrSynchronizableAny, kSecAttrSynchronizable,
                                      key, kSecAttrAccount, nil];
    NSMutableDictionary *query = [search mutableCopy];
    [query setValue:valueData forKey:(__bridge NSString *)kSecValueData];

    OSStatus osStatus;
    //
    // Instead of unconditionally deleting, try the add and if it fails with a duplicate item
    // error, try an update.
    //
    osStatus = SecItemAdd((__bridge CFDictionaryRef) query, NULL);
    if (osStatus == errSecSuccess) {
        resolve(value);
        return;
    }
    if (osStatus == errSecDuplicateItem) {
        NSDictionary *update = @{(__bridge id)kSecValueData:valueData};
        osStatus = SecItemUpdate((__bridge CFDictionaryRef)search,
                                 (__bridge CFDictionaryRef)update);
    }
    if (osStatus != noErr) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:osStatus userInfo:nil];
        reject(@"E_INVALID_NUMBER", @"Input number cannot be 0.", error);
        return;
    }
    resolve(value);
}

- (void)getItem:(NSString *)key resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {

    // Create dictionary of search parameters
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  (__bridge id)(kSecClassGenericPassword), kSecClass,
                                  @"app", kSecAttrService,
                                  key, kSecAttrAccount,
                                  kSecAttrSynchronizableAny, kSecAttrSynchronizable,
                                  kCFBooleanTrue, kSecReturnAttributes,
                                  kCFBooleanTrue, kSecReturnData,
                                  nil];

    // Look up server in the keychain
    NSDictionary* found = nil;
    CFTypeRef foundTypeRef = NULL;
    OSStatus osStatus = SecItemCopyMatching((__bridge CFDictionaryRef) query, (CFTypeRef*)&foundTypeRef);
    
    if (osStatus != noErr && osStatus != errSecItemNotFound) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:osStatus userInfo:nil];
        reject(@"E_INVALID_NUMBER", @"Input number cannot be 0.", error);
    }
    
    found = (__bridge NSDictionary*)(foundTypeRef);
    if (!found) {
        resolve(nil);
    } else {
        // Found
        NSString* value = [[NSString alloc] initWithData:[found objectForKey:(__bridge id)(kSecValueData)] encoding:NSUTF8StringEncoding];
        resolve(value);
    }
}

- (void)deleteItem:(NSString *)key resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {

    // Create dictionary of search parameters
    NSDictionary* query = [NSDictionary dictionaryWithObjectsAndKeys:
                          (__bridge id)(kSecClassGenericPassword), kSecClass,
                          @"app", kSecAttrService,
                          key, kSecAttrAccount,
                          kSecAttrSynchronizableAny, kSecAttrSynchronizable,
                          kCFBooleanTrue, kSecReturnAttributes,
                          kCFBooleanTrue, kSecReturnData,
                          nil];

    // Remove any old values from the keychain
    OSStatus osStatus = SecItemDelete((__bridge CFDictionaryRef) query);
    if (osStatus != noErr && osStatus != errSecItemNotFound) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:osStatus userInfo:nil];
        reject(@"E_INVALID_NUMBER", @"Input number cannot be 0.", error);
        return;
    }
    resolve(nil);
}

@end
