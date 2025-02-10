import { TurboModule, TurboModuleRegistry } from "react-native";

export interface Spec extends TurboModule {
  add(a: number, b: number): Promise<number>;
  getItem(key: string): Promise<string>;
  setItem(key: string, value: string): Promise<void>;
  deleteItem(key: string): Promise<void>;
}

export default TurboModuleRegistry.get<Spec>("RTNCalculator") as Spec | null;
