/** @type {import('next').NextConfig} */
const nextConfig = {

    webpack: (config, context) => {
      // Enable polling based on env variable being set
      if(process.env.NEXT_WEBPACK_USEPOLLING) {
        config.watchOptions = {
          poll: 5000,
          aggregateTimeout:20000,
          ignored: ['**/node_modules']
        }
      }
      return config
    },
  
    async redirects() {
        return [
            {
                source: "/",
                destination: "/demand",
                permanent: true
            }
        ]
    },
    async rewrites() {
      return [
        {
          source: '/.rest/engagements/:path*',
          destination: 'http://supplierengagement-service:8091/.rest/engagements/:path*'
        },
        {
          source: '/.rest/auditrecords/:path*',
          destination: 'http://audit-service:8092/.rest/auditrecords/:path*'
        },
        {
          source: '/.rest/stats/:path*',
          destination: 'http://stats-service:8093/.rest/stats/:path*'
        },
        {
          source: '/.rest/mozsupport/:path*',
          destination: 'http://stats-service:8093/.rest/mozsupport/:path*'
        },
        {
          source: '/.rest/semrush/:path*',
          destination: 'http://stats-service:8093/.rest/semrush/:path*'
        },
        {
          source: '/.rest/orders/:path*',
          destination: 'http://woo-service:8094/.rest/orders/:path*'
        },
        {
          source: '/.rest/:path*',
          destination: 'http://linkservice-service:8090/.rest/:path*'
        }
      ]
    },
    images: {
        remotePatterns: [
          {
            protocol: 'https',
            hostname: 'lh3.googleusercontent.com',
            port: '',
            pathname: '/a/**',
          },
          {
            protocol: 'https',
            hostname: 'avatars.githubusercontent.com',
            port: '',
            pathname: '/u/**',
          },
          
        ],
      },
}

module.exports = nextConfig
