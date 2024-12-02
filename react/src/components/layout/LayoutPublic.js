import React from 'react';
import FooterPublic from './FooterPublic';
import HeaderPublic from './HeaderPublic';
import Head from 'next/head'

const LayoutPublic =({children, pagetitle = " "}) =>{
    
    return(
        <>
            <Head>
                <script async src="https://www.googletagmanager.com/gtag/js?id=G-4K0WX1L508"></script>
                <script>
                    window.dataLayer = window.dataLayer || [];
                    function gtag(){dataLayer.push(arguments)}
                    gtag('js', new Date());

                    gtag('config', 'G-4K0WX1L508');
                </script>
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