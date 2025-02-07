import { TurboModule, TurboModuleRegistry } from "react-native";

export interface RNsensitiveInfoOptions {
  keychainService?: string;
  sharedPreferencesName?: string;
}

export interface Spec extends TurboModule {
  add(a: number, b: number): Promise<number>;
  getItem(key: string, options?: RNsensitiveInfoOptions): Promise<string>;
  setItem(
    key: string,
    value: string,
    options?: RNsensitiveInfoOptions
  ): Promise<void>;
}

export default TurboModuleRegistry.get<Spec>("RTNCalculator") as Spec | null;
