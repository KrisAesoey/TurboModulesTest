package com.rtncalculator

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.rtncalculator.NativeRTNCalculatorSpec

class CalculatorModule(reactContext: ReactApplicationContext) : NativeRTNCalculatorSpec(reactContext) {

  override fun getName() = NAME

  override fun add(a: Double, b: Double, promise: Promise) {
    promise.resolve(a + b)
    emitOnValueChanged(a + b)
  }

  companion object {
    const val NAME = "RTNCalculator"
  }
}