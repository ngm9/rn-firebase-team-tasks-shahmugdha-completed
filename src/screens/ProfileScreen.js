import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { signOut } from 'firebase/auth';
import { auth } from '../config/firebase';

export default function ProfileScreen() {
  const currentUser = auth.currentUser;

  const handleSignOut = async () => {
    try {
      await signOut(auth);
    } catch (e) {
      console.error(e);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.header}>Profile</Text>
      <Text style={styles.email}>{currentUser?.email}</Text>
      <TouchableOpacity style={styles.button} onPress={handleSignOut}>
        <Text style={styles.buttonText}>Sign Out</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f8f8', padding: 24, justifyContent: 'center' },
  header: { fontSize: 22, fontWeight: '700', marginBottom: 8 },
  email: { fontSize: 16, color: '#555', marginBottom: 32 },
  button: { backgroundColor: '#EF4444', padding: 14, borderRadius: 8, alignItems: 'center' },
  buttonText: { color: '#fff', fontSize: 16, fontWeight: '600' },
});