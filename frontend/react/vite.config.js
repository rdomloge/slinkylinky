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
        '/.rest/accounts':     { target: `http://${backend}:8095`, changeOrigin: true },
        '/.rest/engagements':  { target: `http://${backend}:8091`, changeOrigin: true },
        '/.rest/leads':        { target: `http://${backend}:8091`, changeOrigin: true },
        '/.rest/auditrecords': { target: `http://${backend}:8092`, changeOrigin: true },
        '/.rest/stats':        { target: `http://${backend}:8093`, changeOrigin: true },
        '/.rest/mozsupport':   { target: `http://${backend}:8093`, changeOrigin: true },
        '/.rest/semrush':      { target: `http://${backend}:8093`, changeOrigin: true },
        '/.rest/orders':       { target: `http://${backend}:8094`, changeOrigin: true },
        '/.rest':              { target: `http://${backend}:8090`, changeOrigin: true },
        '/realms':    { target: 'http://10.0.0.12:8100', changeOrigin: true },
        '/resources': { target: 'http://10.0.0.12:8100', changeOrigin: true },
      }
    }
  }
})
