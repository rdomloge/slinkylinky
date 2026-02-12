import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: { '@': '/src' }
  },
  server: {
    proxy: {
      '/.rest/engagements': 'http://host.docker.internal:8091',
      '/.rest/auditrecords': 'http://host.docker.internal:8092',
      '/.rest/stats': 'http://host.docker.internal:8093',
      '/.rest/mozsupport': 'http://host.docker.internal:8093',
      '/.rest/semrush': 'http://host.docker.internal:8093',
      '/.rest/orders': 'http://host.docker.internal:8094',
      '/.rest': 'http://host.docker.internal:8080',
      '/realms': 'http://10.0.0.12:8100',
      '/resources': 'http://10.0.0.12:8100',
    }
  }
})
