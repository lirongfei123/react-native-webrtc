/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, { useEffect, useState } from 'react';
import * as RNFS from 'react-native-fs';
import {
  Button,
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  StatusBar,
  Image,
  Platform,
} from 'react-native';
import { Colors } from 'react-native/Libraries/NewAppScreen';
import { mediaDevices, RTCView, FaceAvatarView } from 'react-native-webrtc';
const resolveAssetSource = require('react-native/Libraries/Image/resolveAssetSource');
const downloadAssetSource = require('react-native-opencv3/downloadAssetSource');

const App: () => React$Node = () => {
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
  console.log(FaceAvatarView);
  return (
    <>
      <StatusBar barStyle="dark-content" />
      <SafeAreaView style={styles.body}>
        {
          stream &&
          <RTCView
            streamURL={stream.toURL()}
            onFaceLandmarker={(data) => {
              // console.log(data.nativeEvent.points);
              setPoints(data.nativeEvent.points);
            }}
            style={styles.stream} />
        }
        <FaceAvatarView name="aaa" points={points}></FaceAvatarView>
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
    </>
  );
};

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
