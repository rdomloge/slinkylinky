import React, { useEffect } from 'react';
import FooterPublic from './FooterPublic';
import HeaderPublic from './HeaderPublic';
import Head from 'next/head'

const LayoutPublic =({children, pagetitle = " "}) =>{

    
    
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