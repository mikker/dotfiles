import { defineProfile } from 'superego'

export default defineProfile({
  ui: ['./run/ui.tsx'],
  extensions: ['./run/daemon.ts'],
  description: 'default',
})
