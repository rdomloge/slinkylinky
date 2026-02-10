/** @type {import('next').NextConfig} */
const nextConfig = {

    webpackDevMiddleware: config => {
      config.watchOptions = {
        poll: 5000,
        aggregateTimeout: 20000,
      }
      return config
    },

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
          destination: 'http://host.docker.internal:8091/.rest/engagements/:path*'
        },
        {
          source: '/.rest/auditrecords/:path*',
          destination: 'http://host.docker.internal:8092/.rest/auditrecords/:path*'
        },
        {
          source: '/.rest/stats/:path*',
          destination: 'http://host.docker.internal:8093/.rest/stats/:path*'
        },
        {
          source: '/.rest/mozsupport/:path*',
          destination: 'http://host.docker.internal:8093/.rest/mozsupport/:path*'
        },
        {
          source: '/.rest/semrush/:path*',
          destination: 'http://host.docker.internal:8093/.rest/semrush/:path*'
        },
        {
          source: '/.rest/orders/:path*',
          destination: 'http://host.docker.internal:8094/.rest/orders/:path*'
        },
        {
          source: '/.rest/:path*',
          destination: 'http://host.docker.internal:8080/.rest/:path*'
        },
        {
          source: '/realms/:path*',
          destination: 'http://10.0.0.12:8100/realms/:path*'
        },
        {
          source: '/resources/:path*',
          destination: 'http://10.0.0.12:8100/resources/:path*'
        }
        // these don't need to be edited for prod (they are circumvented with CF tunnels) - you edit the CF tunnel rules under 
        // 'Zero Trust >> Networks >> Tunnels >> your-tunnel >> Configure >> Public Hostnames'
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
            hostname: 'lh3.googleusercontent.com',
            port: '',
            pathname: '/ogw/**',
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
