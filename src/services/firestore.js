import { db } from '../config/firebase';
import { collection, query, where, orderBy, getDocs } from 'firebase/firestore';

export async function fetchUserProfile(uid) {
  const snap = await getDocs(query(collection(db, 'users'), where('uid', '==', uid)));
  if (snap.empty) return null;
  return { id: snap.docs[0].id, ...snap.docs[0].data() };
}

export async function fetchTasksForTeam(teamId) {
  const snap = await getDocs(query(collection(db, 'tasks'), where('teamId', '==', teamId)));
  return snap.docs.map(d => ({ id: d.id, ...d.data() }));
}