/** @type {import('next').NextConfig} */
const nextConfig = {

    webpack: (config, context) => {
      // Enable polling based on env variable being set
      if(process.env.NEXT_WEBPACK_USEPOLLING) {
        config.watchOptions = {
          poll: 5000,
          aggregateTimeout:2000,
          ignored: ['**/node_modules']
    ***REMOVED***
  ***REMOVED***
      return config
***REMOVED***,
  
    async redirects() {
        return [
            {
                source: "/",
                destination: "/demand",
                permanent: true
        ***REMOVED***
        ]
***REMOVED***,
    async rewrites() {
      return [
        {
          source: '/.rest/engagements/:path*',
          destination: 'http://host.docker.internal:8081/.rest/engagements/:path*'
    ***REMOVED***,
        {
          source: '/.rest/auditrecords/:path*',
          destination: 'http://host.docker.internal:8082/.rest/auditrecords/:path*'
    ***REMOVED***,
        {
          source: '/.rest/stats/:path*',
          destination: 'http://host.docker.internal:8083/.rest/stats/:path*'
    ***REMOVED***,
        {
          source: '/.rest/mozsupport/:path*',
          destination: 'http://host.docker.internal:8083/.rest/mozsupport/:path*'
    ***REMOVED***,
        {
          source: '/.rest/semrush/:path*',
          destination: 'http://host.docker.internal:8083/.rest/semrush/:path*'
    ***REMOVED***,
        {
          source: '/.rest/:path*',
          destination: 'http://host.docker.internal:8080/.rest/:path*'
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
          {
            protocol: 'https',
            hostname: 'avatars.githubusercontent.com',
            port: '',
            pathname: '/u/**',
      ***REMOVED***,
          
        ],
  ***REMOVED***,
}

module.exports = nextConfig
