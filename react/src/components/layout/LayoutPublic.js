'use client'

import React from 'react';
import Footer from './Footer';
import HeaderPublic from './HeaderPublic';

const LayoutPublic =({children}) =>{
    
    return(
        <>
            <HeaderPublic/>
            
            <div className="grid grid-cols-8 gap-2">
                <div className="col-span-7 h-full">
                    {children}
                </div>
            </div>
            <Footer/>
        </>
    )
}

export default LayoutPublic;