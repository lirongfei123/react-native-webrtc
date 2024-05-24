/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, { useEffect, useState } from 'react';
import type { PropsWithChildren } from 'react';
import {
  Button,
  NativeModules,
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
} from 'react-native';

import {
  Colors,
  DebugInstructions,
  Header,
  LearnMoreLinks,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';
import  {  mediaDevices, RTCView } from 'react-native-webrtc';
const { WebRTCModule } = NativeModules;
type SectionProps = PropsWithChildren<{
  title: string;
}>;


function App(): React.JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };
  const [stream, setStream] = useState(null);
  const start = async () => {
    console.log('start');
    if (!stream) {
      let s;
      try {
        s = await mediaDevices.getUserMedia({ video: true });
        setStream(s);
      } catch (e) {
        console.error(e);
      }
    }
  };
  const stop = () => {
    console.log('stop');
    if (stream) {
      stream.release();
      setStream(null);
    }
  };
  useEffect(() => {
  }, []);
  const [points, setPoints] = useState([]);
  return (
    <SafeAreaView style={styles.body}>
      {
        stream &&
        <RTCView
          streamURL={stream.toURL()}
          mediapipe={true}
          onFaceLandmarker={(data) => {
            // console.log(data.nativeEvent.points);
            setPoints(data.nativeEvent.points);
          }}
          style={styles.stream} />
      }
      <View
        style={styles.footer}>
        <Button
          title="Start"
          onPress={start} />
        <Button
          title="Stop"
          onPress={stop} />
      </View>
    </SafeAreaView>
  );
}
const styles = StyleSheet.create({
  body: {
    backgroundColor: Colors.white,
    ...StyleSheet.absoluteFill
  },
  stream: {
    position: 'absolute',
    top: 20,
    width: 300,
    height: 300,
    left: 0,
    right: 0
  },
  footer: {
    backgroundColor: Colors.lighter,
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0
  },
});

export default App;
