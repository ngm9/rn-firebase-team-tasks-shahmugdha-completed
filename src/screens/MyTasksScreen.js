import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default function MyTasksScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.header}>My Tasks</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f8f8', padding: 16 },
  header: { fontSize: 22, fontWeight: '700', marginBottom: 16 },
});