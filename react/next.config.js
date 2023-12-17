/** @type {import('next').NextConfig} */
const nextConfig = {

    webpack: (config, context) => {
      // Enable polling based on env variable being set
      if(process.env.NEXT_WEBPACK_USEPOLLING) {
        config.watchOptions = {
          poll: 5000,
          aggregateTimeout:2000,
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
          source: '/.rest/:path*',
          destination: 'http://10.0.0.229:8080/.rest/:path*'
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
        ],
      },
}

module.exports = nextConfig
