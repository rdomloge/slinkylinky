import { SessionProvider } from "next-auth/react";
import ReactGA from 'react-ga4';

export default function App({ Component, pageProps: { session, ...pageProps } }) {

  const TRACKING_ID = "G-4K0WX1L508"; // your Measurement ID
  ReactGA.initialize(TRACKING_ID);

  return (
    <SessionProvider session={session}>
        <Component {...pageProps} />
    </SessionProvider>
  );
}