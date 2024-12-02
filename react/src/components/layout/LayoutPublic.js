import React from 'react';
import FooterPublic from './FooterPublic';
import HeaderPublic from './HeaderPublic';
import Head from 'next/head'
import ReactGA from 'react-ga4';

const LayoutPublic =({children, pagetitle = " "}) =>{

    const TRACKING_ID = "G-4K0WX1L508"; // your Measurement ID
    ReactGA.initialize(TRACKING_ID);

    useEffect(() => {
        ReactGA.initialize(TRACKING_ID);
        // Send pageview with a custom path
        ReactGA.send({ hitType: "pageview", page: "/", title: "Public landing page" });
    }, [])
    
    return(
        <>
            <Head>
                <meta name="robots" content="noindex,nofollow" />
                <title>{"Slinky Linky | " + pagetitle}</title>
            </Head>

            <HeaderPublic/>
            
            <div className="grid grid-cols-8 gap-2">
                <div className="col-span-7 h-full">
                    {children}
                </div>
            </div>
            <FooterPublic/>
        </>
    )
}

export default LayoutPublic;