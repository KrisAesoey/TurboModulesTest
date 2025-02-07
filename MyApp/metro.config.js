const {getDefaultConfig, mergeConfig} = require('@react-native/metro-config');

/**
 * Metro configuration
 * https://reactnative.dev/docs/metro
 *
 * @type {import('@react-native/metro-config').MetroConfig}
 */

const path = require('path');
const projectRoot = path.resolve(__dirname, '../');
const defaultConfig = getDefaultConfig(__dirname);

const config = {
  watchFolders: [projectRoot],
};

module.exports = mergeConfig(defaultConfig, config);
