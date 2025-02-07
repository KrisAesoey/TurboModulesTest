/**
 * This code was generated by [react-native-codegen](https://www.npmjs.com/package/react-native-codegen).
 *
 * Do not edit this file as changes may cause incorrect behavior and will be lost
 * once the code is regenerated.
 *
 * @generated by codegen project: GenerateModuleCpp.js
 */

#include "RTNCalculatorSpecJSI.h"

namespace facebook::react {

static jsi::Value __hostFunction_NativeRTNCalculatorCxxSpecJSI_add(jsi::Runtime &rt, TurboModule &turboModule, const jsi::Value* args, size_t count) {
  return static_cast<NativeRTNCalculatorCxxSpecJSI *>(&turboModule)->add(
    rt,
    count <= 0 ? throw jsi::JSError(rt, "Expected argument in position 0 to be passed") : args[0].asNumber(),
    count <= 1 ? throw jsi::JSError(rt, "Expected argument in position 1 to be passed") : args[1].asNumber()
  );
}

NativeRTNCalculatorCxxSpecJSI::NativeRTNCalculatorCxxSpecJSI(std::shared_ptr<CallInvoker> jsInvoker)
  : TurboModule("RTNCalculator", jsInvoker) {
  methodMap_["add"] = MethodMetadata {2, __hostFunction_NativeRTNCalculatorCxxSpecJSI_add};
}


} // namespace facebook::react
