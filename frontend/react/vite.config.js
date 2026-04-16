import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')
  const backend = env.BACKEND_HOST || 'localhost'

  return {
    plugins: [react()],
    resolve: {
      alias: { '@': '/src' }
    },
    server: {
      proxy: {
        '/.rest/engagements':  `http://${backend}:8091`,
        '/.rest/leads':        `http://${backend}:8091`,
        '/.rest/auditrecords': `http://${backend}:8092`,
        '/.rest/stats':        `http://${backend}:8093`,
        '/.rest/mozsupport':   `http://${backend}:8093`,
        '/.rest/semrush':      `http://${backend}:8093`,
        '/.rest/orders':       `http://${backend}:8094`,
        '/.rest':              `http://${backend}:8090`,
        '/realms':    'http://10.0.0.12:8100',
        '/resources': 'http://10.0.0.12:8100',
      }
    }
  }
})
