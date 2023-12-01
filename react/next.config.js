/** @type {import('next').NextConfig} */
const nextConfig = {
    async redirects() {
        return [
            {
                source: "/",
                destination: "/demand",
                permanent: true
        ***REMOVED***
        ]
***REMOVED***,
    images: {
        remotePatterns: [
          {
            protocol: 'https',
            hostname: 'lh3.googleusercontent.com',
            port: '',
            pathname: '/a/**',
      ***REMOVED***,
        ],
  ***REMOVED***,
}

module.exports = nextConfig
