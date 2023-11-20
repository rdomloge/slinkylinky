'use client'

import React, {useState, useEffect} from 'react'
import '@/styles/globals.css'

export default function LinkDemandCard({linkdemand}) {
    
    if(linkdemand === null) return <p>NULL</p>;
    else return (
        <div className="card">
            <div>{linkdemand.name}</div>
            <div>{linkdemand.url}</div>
            <div>Domain Authority needed {linkdemand.daNeeded}</div>
            <div>Requested {linkdemand.requested}</div>
        </div>
    );
}