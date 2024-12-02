import React from 'react';
import Menu from './Menu';
import Footer from './Footer';
import Header from './Header';
import Head from 'next/head'
import ReactGA from 'react-ga4';


export default function Layout ({children, pagetitle = " "}) {

    const TRACKING_ID = "G-4K0WX1L508"; // your Measurement ID
    ReactGA.initialize(TRACKING_ID);

    useEffect(() => {
        ReactGA.initialize(TRACKING_ID);
        // Send pageview with a custom path
        ReactGA.send({ hitType: "pageview", page: "/", title: "Root" });
    }, [])
    
    return(
        <>
            <Head>
                <meta name="robots" content="noindex,nofollow" />
                <title>{"Slinky Linky | " + pagetitle}</title>
            </Head>
            <Header/>
            
            <div className="grid grid-cols-8 gap-2">
                <div className="">
                    <Menu/>         
                </div>
                <div className="col-span-7 h-full">
                    {children}
                </div>
            </div>
            <Footer/>
        </>
    )
}