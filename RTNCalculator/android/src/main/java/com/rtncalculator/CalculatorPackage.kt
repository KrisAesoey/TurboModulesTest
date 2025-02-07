package com.rtncalculator

import com.facebook.react.BaseReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.model.ReactModuleInfo
import com.facebook.react.module.model.ReactModuleInfoProvider

class CalculatorPackage : BaseReactPackage() {
    override fun getModule(name: String, reactContext: ReactApplicationContext): NativeModule? {
        return if (name == CalculatorModule.NAME) {
            CalculatorModule(reactContext)
        } else {
            null
        }
    }

    override fun getReactModuleInfoProvider(): ReactModuleInfoProvider {
        return ReactModuleInfoProvider {
            mapOf(
                CalculatorModule.NAME to ReactModuleInfo(
                    CalculatorModule.NAME,
                    CalculatorModule::class.java.name,
                    false, // canOverrideExistingModule
                    false, // needsEagerInit
                    true, // isTurboModule
                    false, // isCxxModule
                    true // hasConstants
                )
            )
        }
    }
}
