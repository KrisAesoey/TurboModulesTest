package com.rtncalculator

import android.content.Context
import android.content.SharedPreferences
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.rtncalculator.NativeRTNCalculatorSpec

class CalculatorModule(reactContext: ReactApplicationContext) : NativeRTNCalculatorSpec(reactContext) {

  override fun getName() = NAME

  override fun add(a: Double, b: Double, promise: Promise) {
    promise.resolve(a + b)
  }

  override fun setItem(key: String, value: String, promise: Promise) {
    try {
      val sharedPref = reactApplicationContext.getSharedPreferences("preferences", Context.MODE_PRIVATE)
      val editor = sharedPref.edit()
      editor.putString(key, value).apply()
      promise.resolve(value)
    } catch (e: Exception) {
        promise.reject("SET_ITEM_ERROR", "Failed to set item", e)
    }
  }

  override fun getItem(key: String, promise: Promise) {
    try {
      val sharedPref = reactApplicationContext.getSharedPreferences("preferences", Context.MODE_PRIVATE)
      val value = sharedPref.getString(key, null)
      promise.resolve(value)
    } catch (e: Exception) {
      promise.reject("GET_ITEM_ERROR", "Failed to get item", e)
    }
  }

  override fun deleteItem(key: String, promise: Promise) {
    try {
      val sharedPref = reactApplicationContext.getSharedPreferences("preferences", Context.MODE_PRIVATE)
      val editor = sharedPref.edit()
      editor.remove(key)
      editor.apply()
      promise.resolve(null) // Resolve with `null` since it's a `Promise<void>`
    } catch (e: Exception) {
      promise.reject("DELETE_ITEM_ERROR", "Failed to delete item", e)
    }
  }

  companion object {
    const val NAME = "RTNCalculator"
  }
}