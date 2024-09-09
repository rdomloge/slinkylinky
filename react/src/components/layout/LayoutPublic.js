'use client'

import React from 'react';
import FooterPublic from './FooterPublic';
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
            <FooterPublic/>
        </>
    )
}

export default LayoutPublic;