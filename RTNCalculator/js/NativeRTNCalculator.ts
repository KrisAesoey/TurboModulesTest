import { TurboModule, TurboModuleRegistry } from "react-native";
import { EventEmitter } from "react-native/Libraries/Types/CodegenTypes";

export interface Spec extends TurboModule {
  add(a: number, b: number): Promise<number>;
  readonly onValueChanged: EventEmitter<number>;
}

export default TurboModuleRegistry.get<Spec>("RTNCalculator") as Spec | null;
