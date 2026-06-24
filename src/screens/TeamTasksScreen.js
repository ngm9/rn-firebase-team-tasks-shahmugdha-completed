import React, { useState, useEffect } from 'react';
import { View, Text, FlatList, TouchableOpacity, StyleSheet, ActivityIndicator } from 'react-native';
import { collection, getDocs, updateDoc, doc } from 'firebase/firestore';
import { db, auth } from '../config/firebase';

export default function TeamTasksScreen() {
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchTasks = async () => {
      try {
        const snapshot = await getDocs(collection(db, 'tasks'));
        const data = snapshot.docs.map(d => ({ id: d.id, ...d.data() }));
        setTasks(data);
      } catch (e) {
        console.error(e);
      } finally {
        setLoading(false);
      }
    };
    fetchTasks();
  }, []);

  const cycleStatus = async (task) => {
    const next = task.status === 'todo' ? 'in_progress' : task.status === 'in_progress' ? 'done' : 'todo';
    await updateDoc(doc(db, 'tasks', task.id), { status: next });
  };

  if (loading) return <ActivityIndicator style={{ flex: 1 }} />;

  return (
    <View style={styles.container}>
      <Text style={styles.header}>Team Tasks</Text>
      <FlatList
        data={tasks}
        keyExtractor={item => item.id}
        renderItem={({ item }) => (
          <TouchableOpacity style={styles.taskCard} onPress={() => cycleStatus(item)}>
            <Text style={styles.taskTitle}>{item.title}</Text>
            <Text style={styles.taskMeta}>Status: {item.status} | Priority: {item.priority}</Text>
          </TouchableOpacity>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f8f8', padding: 16 },
  header: { fontSize: 22, fontWeight: '700', marginBottom: 16 },
  taskCard: { backgroundColor: '#fff', padding: 14, borderRadius: 8, marginBottom: 10, elevation: 1 },
  taskTitle: { fontSize: 16, fontWeight: '600' },
  taskMeta: { fontSize: 13, color: '#666', marginTop: 4 },
});