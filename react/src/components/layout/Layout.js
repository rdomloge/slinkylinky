import React from 'react';
import Menu from './Menu';
import Footer from './Footer';
import Header from './Header';
import Head from 'next/head'


export default function Layout ({children, pagetitle = " "}) {
    
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