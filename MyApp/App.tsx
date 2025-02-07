/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */
import React, {useState} from 'react';
import {Alert, Button, SafeAreaView, StatusBar, Text} from 'react-native';
import RTNCalculator from 'rtn-calculator/js/NativeRTNCalculator.ts';

const App: () => JSX.Element = () => {
  const [result, setResult] = useState<number | null>(null);

  React.useEffect(() => {
    const listenerSubscription = RTNCalculator?.onValueChanged(data => {
      Alert.alert(`Result: ${data}`);
    });

    return () => {
      listenerSubscription?.remove();
    };
  }, []);

  return (
    <SafeAreaView>
      <StatusBar barStyle={'dark-content'} />
      <Text style={{marginLeft: 20, marginTop: 20}}>3+7={result ?? '??'}</Text>
      <Button
        title="Compute"
        onPress={async () => {
          const value = await RTNCalculator?.add(3, 7);
          setResult(value ?? null);
        }}
      />
    </SafeAreaView>
  );
};
export default App;
