/** @type {import('next').NextConfig} */
const nextConfig = {
  
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
