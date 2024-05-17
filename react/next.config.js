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
          destination: 'http://host.docker.internal:8081/.rest/engagements/:path*'
        },
        {
          source: '/.rest/auditrecords/:path*',
          destination: 'http://host.docker.internal:8082/.rest/auditrecords/:path*'
        },
        {
          source: '/.rest/stats/:path*',
          destination: 'http://host.docker.internal:8083/.rest/stats/:path*'
        },
        {
          source: '/.rest/mozsupport/:path*',
          destination: 'http://host.docker.internal:8083/.rest/mozsupport/:path*'
        },
        {
          source: '/.rest/semrush/:path*',
          destination: 'http://host.docker.internal:8083/.rest/semrush/:path*'
        },
        {
          source: '/.rest/orders/:path*',
          destination: 'http://host.docker.internal:8084/.rest/orders/:path*'
        },
        {
          source: '/.rest/:path*',
          destination: 'http://host.docker.internal:8080/.rest/:path*'
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
