import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import TeamTasksScreen from '../screens/TeamTasksScreen';
import MyTasksScreen from '../screens/MyTasksScreen';
import ProfileScreen from '../screens/ProfileScreen';

const Tab = createBottomTabNavigator();

export default function MainTabs() {
  return (
    <Tab.Navigator>
      <Tab.Screen name="TeamTasks" component={TeamTasksScreen} options={{ title: 'Team Tasks' }} />
      <Tab.Screen name="MyTasks" component={MyTasksScreen} options={{ title: 'My Tasks' }} />
      <Tab.Screen name="Profile" component={ProfileScreen} />
    </Tab.Navigator>
  );
}