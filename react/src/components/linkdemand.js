'use client'

import React, {useState, useEffect} from 'react'

export default function LinkDemandCard({linkdemand}) {
    
    if(linkdemand === null) return <p>NULL</p>;
    else return (
        <div>
            <div>Demand:  {linkdemand.name}</div>
        </div>
    );
}